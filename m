Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 409F9CB0F4
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 23:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731371AbfJCVRp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 17:17:45 -0400
Received: from mail-eopbgr730044.outbound.protection.outlook.com ([40.107.73.44]:46240
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727789AbfJCVRo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 17:17:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xh1GUcGH7wot7Gn8TYnIg3uToFIZOrvndTaYyZtNb1qjTmgn4MpbGJbMbqWBfBMgkmrysjmzfqERl52KSGNldjW57+WxccIcktbDeS8F7nTj0HwOlckCFkGpPnWiCJNaOtlBOdOs3VP4oEETDHbtvNdQ1XY62Fj/mGlsA7t+zRPglESPiMi0Q9Xbv8S6cEskpiNXXvNUOw8RDd2PJcq93jvCdBSopPlKeSBRB/+k/8wdaKDvBy7h3irh9aq5sV4Me6umKRyE+3c3ByZqKrZCxRhy8sFXnr+euxa/C0iPkabblK7bU+lj/auF0cjGfUEhmfJGWguXXyneqGcc8q7Acw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XykmkkuZiFPc1sAZo3nrIR4fnLv6b1zXkHkJqbpZlZ8=;
 b=dbsnN2Yp7XYb9BZME+aqNIEhdfCMzt5mntZ8rVxSoVWaijUryEbmH1uvFUwLgigsQOP8XN+kiByJVw45tF3JRQaJHvSLCXKTCESfxl0uby795WaDhKa4ZT4gM4h4Jh6/fSOZCetq8Dy1IcTzaR5sUavBb42zm+utlePS1kb3C9oPHDFYZ5I18dav0rbAWgl45UazEkYvPGqi60/Qe79x9tto1ufpJHsLUTU6xbTBiei3VFf3lipKtJIn2EHcoMZtX9ahLp5O4KWzC7YqieVgt4Ke+S4i7KXx6uia0atLyItb2rnAPlVB7WMD1VfgktrFpNNNQBJwmLJGxqYxqG3zUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XykmkkuZiFPc1sAZo3nrIR4fnLv6b1zXkHkJqbpZlZ8=;
 b=Vta+9zqSCbM46rP75lk58TdSLXwr32HBcWB4bTG8AlhItj5b9OTfcvGIVBy/Gx/HgaCamR4bphmCH7zpLeMK6YvY4k3LVi3ucbr4ZqK6qIReQb6ywQMYs134YXOXNicnV4nIdpwzacH7y7FiGK4a+69TVFwuOR4zU8I+gNBq4H0=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB3211.namprd12.prod.outlook.com (20.179.105.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Thu, 3 Oct 2019 21:17:42 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::85b7:7456:1a67:78aa]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::85b7:7456:1a67:78aa%7]) with mapi id 15.20.2305.023; Thu, 3 Oct 2019
 21:17:42 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        =?iso-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH 0/5] SEV fixes and performance enhancements
Thread-Topic: [PATCH 0/5] SEV fixes and performance enhancements
Thread-Index: AQHVei/+m230dNdjaEiFD9na+UoMxQ==
Date:   Thu, 3 Oct 2019 21:17:42 +0000
Message-ID: <cover.1570137447.git.thomas.lendacky@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SN6PR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:805:de::19) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:182::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 107dc618-4be3-43c6-8d74-08d74847206b
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM6PR12MB3211:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB32119FD1CFE01D20404D6F98EC9F0@DM6PR12MB3211.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:873;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(376002)(346002)(366004)(136003)(199004)(189003)(256004)(26005)(14444005)(386003)(6506007)(316002)(4744005)(36756003)(66446008)(71200400001)(71190400001)(5660300002)(66476007)(66556008)(64756008)(66946007)(66066001)(8936002)(2501003)(50226002)(7416002)(6512007)(6306002)(102836004)(81156014)(8676002)(2906002)(14454004)(81166006)(7736002)(4326008)(6436002)(305945005)(478600001)(966005)(25786009)(86362001)(476003)(2616005)(186003)(6486002)(54906003)(99286004)(110136005)(486006)(52116002)(3846002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3211;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7b2d93MzHyd29yRYfEtOAYt75dsFDFkF5hIk8qztgLHhaezbE34NsYrT59DJwkWQhDhOOjLJbCMrnMi7waTm1E2Ed+j1iLyx/6O4CmVNvvroFGzYLxh+0qWQBJl6jPDQXl9uRXJPbWsUPp0JIFfT2+2el5iBq6fUgNIYbugPOeXry1uIK99GLRoptPnf9qHLGG3KhOAFMvaSyLN2lZOhBwPWxjZYScy24tImQYbAPTl0UKabo0zoNrzRy82CHrX1dt/HCW0HbMQQt4KcScJ1RsFUGSYlg7lzT3c7doWghu3oByhsjgcMLVZBX47BBCHx2jqYB5iO34kqby8281USTupdmtROPqTnSNT+UA7/JG93q66fQn/d/wfXHLk0CXI5z4NIPY9UbSIzzSRpw6B72S0qXlGWgYEwZt7oo7JPmB3HTuH5uimTGn7JyZi6Xt+B86BaXztFUdkLp5RtlGXQ4w==
Content-Type: text/plain; charset="iso-8859-2"
Content-ID: <815C7A99E43A514B91700271E42C6B99@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 107dc618-4be3-43c6-8d74-08d74847206b
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 21:17:42.2230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wFxgXjsrqNtwe8CFWbCg9p3nuZVohk/ZIvb5UHwOdgcysUArcKYjJwIrVqU7O0cfjNOMuM9Mtb8ZpDvWVQHUPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3211
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

This patch series provides fixes in the area of ASID assignment and VM
deactivation.

Additionally, it provides some performance enhancements by reducing the
number of WBINVD/DF_FLUSH invocations that are made.

Note: The third patch in the series modifies a file that is outside of
      the arch/x86/kvm directory.

---

Patches based on https://git.kernel.org/pub/scm/virt/kvm/kvm.git next
and commit:
  fd3edd4a9066 ("KVM: nVMX: cleanup and fix host 64-bit mode checks")

Tom Lendacky (5):
  KVM: SVM: Serialize access to the SEV ASID bitmap
  KVM: SVM: Guard against DEACTIVATE when performing WBINVD/DF_FLUSH
  KVM: SVM: Remove unneeded WBINVD and DF_FLUSH when starting SEV guests
  KVM: SVM: Convert DEACTIVATE mutex to read/write semaphore
  KVM: SVM: Reduce WBINVD/DF_FLUSH invocations

 arch/x86/kvm/svm.c           | 105 +++++++++++++++++++++++++++--------
 drivers/crypto/ccp/psp-dev.c |   9 +++
 2 files changed, 92 insertions(+), 22 deletions(-)

--=20
2.17.1

