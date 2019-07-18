Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBE7E6D278
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 19:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbfGRRCO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 13:02:14 -0400
Received: from mail-eopbgr790088.outbound.protection.outlook.com ([40.107.79.88]:1460
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726040AbfGRRCO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 13:02:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RXJqP2zcZ1mclGhasGKM7UWcP90cs62LtgspzhDEkOVwg2LLHrRQZoScJx2NvsZMOCYO8EM3gUR0zVOgT0W2Yr6ZxEuMaS5bY7XCdnYXYUAex0H2+SWa8wnNehGyjp8g6dL71k2GAcnrmiglKumO71ahvPzE1tORYdnIDFCSdKSiBlp5L+8o1tnZSnVlxzbbbZwlUiY6mfrLLAlVijdqX9/hsBgbaMs26WFIB68MiKssWTy+DUpdkD0COGpWDeaQ74C6mjlBbZ0zPv0OaUUhHW/yFAobf8tbEZ546mdWawMsdpO+T9DgCKFYbqvZoIhX96lMl+qEO4J+Gjgd93SdzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y/6g0lbBmPe8icy0EOaITt7XapN2C0qB3+2KSYGqB7M=;
 b=N9pyho9BFf+BUiZaquvt1J3kbfN71Po2MoVfjL0vOCaNqaeV1G0Qb/9kDVekyZxin0sH8P/VTmK/YWNwsGq09S9SgtiNEcF17q5ZSTEd2FjFuaqkcY172PcMVwQzK8asYPyGGR9LOOZYvH/vXUxsAK6V8fUOyMbxoLYEgL52bsR5OCbF3rXUDrnmQcUqWEdGrr673pOfW6wyKChcE4AhMOZ4DVh40fwJF3n9b2QyEjgMuK6wmm0gnHZYCQyMaHnKEc7GkSB5p7Q647a0A1apRhiyVPiVGZAv7qoUBuAD82t4QMdruLTUUhEBbFjTbd3lDUmFOlwk/No1AoRHuxkkoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=vmware.com;dmarc=pass action=none
 header.from=vmware.com;dkim=pass header.d=vmware.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y/6g0lbBmPe8icy0EOaITt7XapN2C0qB3+2KSYGqB7M=;
 b=uB51C6OlNx5cFtbU8VL9xo0jBf8/GGwaFMWzDDdfkA6ZLdkz9ivFEwSl3/Wjv+i8tZD71//s6P5ONdYDps+8TjTFMdJ4eaiVPuM/ABaO7EWJyvtvCvJ0xgKaLBtZdj8ecvAoeZDJjmxHNkYwweILjixOkiy856O3gbmNKohQoL4=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (52.135.233.146) by
 BYAPR05MB4775.namprd05.prod.outlook.com (52.135.233.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.10; Thu, 18 Jul 2019 17:02:07 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::e00b:cb41:8ed6:b718]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::e00b:cb41:8ed6:b718%2]) with mapi id 15.20.2094.009; Thu, 18 Jul 2019
 17:02:07 +0000
From:   Nadav Amit <namit@vmware.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Wei Wang <wei.w.wang@intel.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Xavier Deguillard <xdeguillard@vmware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "pagupta@redhat.com" <pagupta@redhat.com>,
        Rik van Riel <riel@surriel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "yang.zhang.wz@gmail.com" <yang.zhang.wz@gmail.com>,
        "nitesh@redhat.com" <nitesh@redhat.com>,
        "lcapitulino@redhat.com" <lcapitulino@redhat.com>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alexander.h.duyck@linux.intel.com" 
        <alexander.h.duyck@linux.intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Subject: Re: [PATCH v2] mm/balloon_compaction: avoid duplicate page removal
Thread-Topic: [PATCH v2] mm/balloon_compaction: avoid duplicate page removal
Thread-Index: AQHVPVETq+d/PdgRAE68BsHO2xGkqabQTVWAgABNFwA=
Date:   Thu, 18 Jul 2019 17:02:07 +0000
Message-ID: <4FC18511-DD19-4B10-BCAF-906E264B0411@vmware.com>
References: <1563442040-13510-1-git-send-email-wei.w.wang@intel.com>
 <20190718082535-mutt-send-email-mst@kernel.org>
In-Reply-To: <20190718082535-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [66.170.99.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d8161b6-8a25-4510-6e31-08d70ba1aac1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR05MB4775;
x-ms-traffictypediagnostic: BYAPR05MB4775:
x-microsoft-antispam-prvs: <BYAPR05MB4775C2FD7924573D5C548257D0C80@BYAPR05MB4775.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01026E1310
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(366004)(136003)(376002)(39860400002)(199004)(189003)(64756008)(76116006)(6512007)(66476007)(66446008)(25786009)(66946007)(68736007)(53936002)(33656002)(66556008)(6246003)(316002)(6116002)(7736002)(6486002)(36756003)(4326008)(2906002)(476003)(3846002)(305945005)(6436002)(6916009)(71200400001)(14454004)(8676002)(71190400001)(11346002)(446003)(86362001)(4744005)(486006)(26005)(66066001)(102836004)(76176011)(6506007)(5660300002)(53546011)(186003)(14444005)(99286004)(81156014)(81166006)(256004)(8936002)(478600001)(7416002)(54906003)(229853002)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4775;H:BYAPR05MB4776.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3H4cEqrf76gadOEu7acGHaUp5c8KWfuWofhQDbzvWLRAvZr4mBBLwLrB38FfZRDHVUrYTIZsaiNJ+Ko9HGHdqkrxpWh7rGyqUT4hJNhjU23G/k4UBKejLBwgTMm7kZQ4Bycu6Wroo0fazmwvVkb0EQ+6tu9mCQqico1BmtbgQgrR3Sa8MD5bcYCnaYO/iIfm6gAF5jsRZ/rF+lh60OIgYDhZFuUX+1PtiZ4l7/otRhpZYCIJmJmPJTfzL4ZFKrFkjVLpljwe9sFEnWMvVivguzTFSKgNmbVYg7L9mskxGaDcBtHMfrzJnnXtBA8rE7aKFWvn0oSPs2wstUMkrCQlnimBbK47oGOHxcSQ/RFdzxC1gtcthRrr/0YrePNke9kIelCYcu+svH1aFNARBIOrr4e++fPWyl0QPZSq1JQwQvw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B3E1CA15BF28004E91F935580443763C@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d8161b6-8a25-4510-6e31-08d70ba1aac1
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2019 17:02:07.5889
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: namit@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4775
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jul 18, 2019, at 5:26 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
>=20
> On Thu, Jul 18, 2019 at 05:27:20PM +0800, Wei Wang wrote:
>> Fixes: 418a3ab1e778 (mm/balloon_compaction: List interfaces)
>>=20
>> A #GP is reported in the guest when requesting balloon inflation via
>> virtio-balloon. The reason is that the virtio-balloon driver has
>> removed the page from its internal page list (via balloon_page_pop),
>> but balloon_page_enqueue_one also calls "list_del"  to do the removal.
>> This is necessary when it's used from balloon_page_enqueue_list, but
>> not from balloon_page_enqueue_one.
>>=20
>> So remove the list_del balloon_page_enqueue_one, and update some
>> comments as a reminder.
>>=20
>> Signed-off-by: Wei Wang <wei.w.wang@intel.com>
>=20
>=20
> ok I posted v3 with typo fixes. 1/2 is this patch with comment changes. P=
ls take a look.

Thanks (Wei, Michael) for taking care of it. Please cc me on future
iterations of the patch.

Acked-by: Nadav Amit <namit@vmware.com>

