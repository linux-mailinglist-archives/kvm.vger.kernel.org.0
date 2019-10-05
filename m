Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F53DCCB90
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2019 19:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387537AbfJERHq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Oct 2019 13:07:46 -0400
Received: from mail-eopbgr790104.outbound.protection.outlook.com ([40.107.79.104]:37248
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725826AbfJERHp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Oct 2019 13:07:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JU1dTblbWOb1N4XMlC4j//xJsrvTvIL5f6P+hQaMHeWKV5pqwgNI0oz/BQ0CSQ4KOpUocyRcpPwKpOvdQ2vOT6nDOpTUufozQA7DIEuNIDBGHacovutc/8bK4dQ+IVPcpIldUOCIRXuShkYzTNlckIEj1jzozddi/ip9N+kZBz1vM3D4E7e3fwsNUuKaE2lRWji0RQrzuRXFHcnTGJukt+rYUbO5XUSyu6uox6W6qy0s4F/rSDN8mpCJajsmddoIpEhHXwwHMBG4YiivFsQcgHGl/uRL4rUoQnETvdkqLDSfYF32Eh3vUkdQMoQ6sQByWCQSqtVQbE59z5kldEQfLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ykYRDN50MUPe9vqF8SnRBLfv/e0lUiab4pzeAYImQm8=;
 b=P/k8LjvpbzP6CQT13X7hEReEdAI19RG5icPJa2vYRlxJtKSP1UPIyZbHQCoHZ/fE5Hc171IVOdgVASOyUyh+7btRizDRBPGxx8KvKt5MGEAe+Fq0ZfU9RWtwkno5m3wTJZ0nqHzzO8dWBVnKrpT7M+Shy/Pq7N0uvexQ9iIpIvV7suwEn4BorZOtyZzsRlW97NrAk5qaeilGU1ou0+XxKp94AnTrH302W1dtvY0OwYr0TSQyE4jZUTR2HRBsYMJTyvngTAWLS+XXHhDG/lsnD+oAwEcVD0olD8R9rzM72DBlNh7NQFTYV6WAhSfB4He6KqIHnUTIr1Fonrh4B+qN/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ykYRDN50MUPe9vqF8SnRBLfv/e0lUiab4pzeAYImQm8=;
 b=hh4phBLEhyIphK3geBgYkm3lTPhMhbBrfNGbUAyNrTS6oFYIJOBgqntxvHkbFngp/KYmexOHid5vu+rUl47nVV+TTTArGvaiuKFotLZ+7Ux0NfBuUA94uR9M5SFSvMPvSulBp1jdb79Px42TwDKMJ59zKc/yglorIYCYv/7oGyk=
Received: from DM5PR21MB0137.namprd21.prod.outlook.com (10.173.173.12) by
 DM5PR21MB0745.namprd21.prod.outlook.com (10.173.172.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.11; Sat, 5 Oct 2019 17:07:02 +0000
Received: from DM5PR21MB0137.namprd21.prod.outlook.com
 ([fe80::a50f:aa3c:c7d6:f05e]) by DM5PR21MB0137.namprd21.prod.outlook.com
 ([fe80::a50f:aa3c:c7d6:f05e%11]) with mapi id 15.20.2347.012; Sat, 5 Oct 2019
 17:07:02 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     vkuznets <vkuznets@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: RE: [PATCH v4 4/4] x86/hyperv: Mark "hv_nopvspin" parameter obsolete
Thread-Topic: [PATCH v4 4/4] x86/hyperv: Mark "hv_nopvspin" parameter obsolete
Thread-Index: AQHVerwRUoDH1CpwOk2j+xAs0Api66dMSNGQ
Date:   Sat, 5 Oct 2019 17:07:02 +0000
Message-ID: <DM5PR21MB0137632BCB5396630281E07FD7990@DM5PR21MB0137.namprd21.prod.outlook.com>
References: <1570111335-12731-1-git-send-email-zhenzhong.duan@oracle.com>
 <1570111335-12731-5-git-send-email-zhenzhong.duan@oracle.com>
In-Reply-To: <1570111335-12731-5-git-send-email-zhenzhong.duan@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-10-05T17:07:00.3174886Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e27722ac-7d8c-451c-b5ce-d145ca606cb6;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b87dca7-d3bc-433a-60f2-08d749b67132
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM5PR21MB0745:|DM5PR21MB0745:|DM5PR21MB0745:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM5PR21MB07455DB29833AF8FFCB22978D7990@DM5PR21MB0745.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:220;
x-forefront-prvs: 0181F4652A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(366004)(136003)(376002)(396003)(346002)(189003)(199004)(81166006)(81156014)(8676002)(8936002)(6246003)(74316002)(305945005)(2501003)(66066001)(7416002)(6116002)(3846002)(256004)(14444005)(10090500001)(4326008)(486006)(52536014)(4744005)(229853002)(9686003)(476003)(11346002)(55016002)(6506007)(186003)(86362001)(6436002)(71190400001)(71200400001)(7736002)(5660300002)(102836004)(446003)(26005)(14454004)(76176011)(33656002)(110136005)(54906003)(76116006)(66556008)(99286004)(25786009)(7696005)(66946007)(8990500004)(64756008)(66476007)(66446008)(2906002)(22452003)(316002)(478600001)(10290500003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR21MB0745;H:DM5PR21MB0137.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p3zTX3yofiyPdO+3Zd6QwfKZCkfMFBs7eBh1RrH771veCfrR9lDdk5xmCFxpCyPG1ooPQdUwNkJS4k9cAC4OaZAoTGywOOjFbCNgs7YnurU0nsI9ICZar/v1ThoE3MA7V1DGk/4shDIKp186sXwyDNbZLLPQk1xeMS+QXfOpV2rNffOsDyJSPN91QNJv1arOLC6f8cazwYwyiPWAaH/iylVvvdqDne3XOFWZrVAaXEELEU7xODYbiag0kKdXBE7ewLP1UooiVuTLa4b7kONagqtzvqPBcZU2LYoiQgB9jYMY9sEl9m8qt502GYeG8eTEibSEHm2hnXv/3vPUeDZe1/wYLgzjiPE24pTJc3ZKVFwXNN3tw9KMRFvDMoEy2L39eBRcT79kMhHfklwLEwARzoRzDK2OpNrE+Ge9UhX/W0w=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b87dca7-d3bc-433a-60f2-08d749b67132
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2019 17:07:02.7237
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9DYvOqhtClNaTT+bONah5c2/G5V3e1oGQKdQ2LCGcz9EM9j35uWXelRB2RzfJxhUsVpnUMZjYrDnHGZj2ieof8SOvQO5b9MwkLpRB+j5loM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0745
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zhenzhong Duan <zhenzhong.duan@oracle.com>  Sent: Thursday, October 3=
, 2019 7:02 AM
>=20
> Map "hv_nopvspin" to "nopvspin".
>=20
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: Stephen Hemminger <sthemmin@microsoft.com>
> Cc: Sasha Levin <sashal@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> ---
>  Documentation/admin-guide/kernel-parameters.txt | 6 +++++-
>  arch/x86/hyperv/hv_spinlock.c                   | 4 ++++
>  2 files changed, 9 insertions(+), 1 deletion(-)
>=20

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
