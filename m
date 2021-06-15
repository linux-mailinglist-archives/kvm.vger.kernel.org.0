Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF153A76EC
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 08:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhFOGOj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 02:14:39 -0400
Received: from mail-vi1eur05on2040.outbound.protection.outlook.com ([40.107.21.40]:64671
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229493AbhFOGOg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 02:14:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l8RnEFNFzmyl5Q14B3pkSW06F+C/zg8GMv4IGrZayBs=;
 b=xZ8I+VOCkDW8RfCcM1VpdeGTrjVGR9a7xBoFW4cPK4P9ai7bS9qYwPnAHIi8DtcfKmlbxs2UVxEen4HxKxTPQd5ho/8t08nOyO8r2ThyrDVaFA9i4HfCj2EV10iWtE5uXULeQQPbMygfK6lMq8kZvEZcdcwhE8X9/kyxrEBs7/8=
Received: from AM6P193CA0040.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:8e::17)
 by AM9PR08MB6998.eurprd08.prod.outlook.com (2603:10a6:20b:419::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Tue, 15 Jun
 2021 06:12:23 +0000
Received: from VE1EUR03FT026.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:8e:cafe::30) by AM6P193CA0040.outlook.office365.com
 (2603:10a6:209:8e::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend
 Transport; Tue, 15 Jun 2021 06:12:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT026.mail.protection.outlook.com (10.152.18.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4219.21 via Frontend Transport; Tue, 15 Jun 2021 06:12:23 +0000
Received: ("Tessian outbound 596959d6512a:v93"); Tue, 15 Jun 2021 06:12:23 +0000
X-CR-MTA-TID: 64aa7808
Received: from 4fd48cca6d3f.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 3F5C6526-3516-45A3-BC98-AD873FC17A2C.1;
        Tue, 15 Jun 2021 06:12:11 +0000
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 4fd48cca6d3f.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 15 Jun 2021 06:12:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OVA9kMe+UmhuIOhF51BpA5e2ee10Lvcd/Fqs/z7xMpHdGJp74H1cQn812xvLIpNRfGRHhO1o2ScpCS1Zy7pGoncpDT3Vp/VnxTqMk2H333lgUzu3jYASt42LROJ7IXHfk9JXNSYB5GnImDdZ8XmlDa/vky9A9hgxMcrw8GmFREhdAyNzUbPCmzWFwmPovmD+gswMaSEZPfZicjiFwlX4R8jrurKnkvh+8Jy0zu149v+T4Q3fNccHBzHWy+uYJtDrS0sis4CoxlZZLUhP1N5YmKDNmqSf9nVFaZ3jV7JV7+dAtrEbG1Snc58yU0hCzj1nlNST75cf4syp01UZi/QQcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l8RnEFNFzmyl5Q14B3pkSW06F+C/zg8GMv4IGrZayBs=;
 b=Y9iWLfwby7aMfozgOIpDzHgF87nMOMthMxig7m0gSAqIHddDRHejGJZPru+j7eVfD4t0oI5I8/Nm1OwtZhgYmok5N31/RiZTszdq9rNegPwO7GVGwiKw2wRQa8DLDLtW4iFAk7UpGcljLmq3TF0xsYh71kHbaPBtSeKce1Jv+y6eV8Z57hlGCl66f9BAMLBaC4CyR2146x4gi+QRb+1Cad103s8aU0vxQ7BURRbY9oyeH/bGYXvF+l7jn5n9vQvRWjeLp6m6Czs6RSeq/73ARqYJpnHMoi7EC7iLI9mLBmzVTV05Z91ZSlnaeTfpTpYqaJwgXvJm8H2t6CBlDsj6mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l8RnEFNFzmyl5Q14B3pkSW06F+C/zg8GMv4IGrZayBs=;
 b=xZ8I+VOCkDW8RfCcM1VpdeGTrjVGR9a7xBoFW4cPK4P9ai7bS9qYwPnAHIi8DtcfKmlbxs2UVxEen4HxKxTPQd5ho/8t08nOyO8r2ThyrDVaFA9i4HfCj2EV10iWtE5uXULeQQPbMygfK6lMq8kZvEZcdcwhE8X9/kyxrEBs7/8=
Received: from DB9PR08MB6857.eurprd08.prod.outlook.com (2603:10a6:10:2a2::7)
 by DB7PR08MB3178.eurprd08.prod.outlook.com (2603:10a6:5:24::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.24; Tue, 15 Jun
 2021 06:12:10 +0000
Received: from DB9PR08MB6857.eurprd08.prod.outlook.com
 ([fe80::2078:8a4d:fb01:8143]) by DB9PR08MB6857.eurprd08.prod.outlook.com
 ([fe80::2078:8a4d:fb01:8143%6]) with mapi id 15.20.4195.032; Tue, 15 Jun 2021
 06:12:09 +0000
From:   Wei Chen <Wei.Chen@arm.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
CC:     "will@kernel.org" <will@kernel.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        Julien Grall <julien@xen.org>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        "julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <Oleksandr_Tyshchenko@epam.com>
Subject: [Kvmtool] Some thoughts on using kvmtool Virtio for Xen
Thread-Topic: [Kvmtool] Some thoughts on using kvmtool Virtio for Xen
Thread-Index: Addhq3Jd+FbZaJt0R6WdbgcPW7X96w==
Date:   Tue, 15 Jun 2021 06:12:08 +0000
Message-ID: <DB9PR08MB6857B375207376D8320AFBA89E309@DB9PR08MB6857.eurprd08.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 9DF71AC55BCB6443A06FF2F1548551B3.0
x-checkrecipientchecked: true
Authentication-Results-Original: vger.kernel.org; dkim=none (message not
 signed) header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 7edeb86c-34f6-429d-f2dd-08d92fc48aa4
x-ms-traffictypediagnostic: DB7PR08MB3178:|AM9PR08MB6998:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM9PR08MB6998EFBE96004F2509E0E1F69E309@AM9PR08MB6998.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: yAbx9fQRPoSzBa6DuAwtnUvK6HXeU+iazrkhGR8UB1fECCLwfb5FvKIrmqfeTQGlJET0uxNJbBKMkITHGG4zDE///s6fjCHkvIL5kKZm7oNkERkCMlMNR6A7LDI10UyA7ksDp8BE0l9Z3L22RPPDoGcuAjxeZQnBK1roDXX+f87zvPviSjg1/E6JAICh+BQGVs0C5d045QJu3gWzca4Nw0AMjwz1+7777zXN+oV4nRVjjTC13RnApDjc3BqVlWfg4L0HmYyqYvmvvCwLN713rGj6jS9oRtwlslD9RZL7Ab5fUhlHD0EHKOUzIxJHQNDY9gd9OvARR0NWyUeFZhp5B/9xjaFSRLExbphdBCtiUnRMx7efJJqR7jxhDlBuTO/H6scvwa6U/s2HDGvIAb2/kJxtoFI3UQLhNX1r4d54C4WgG85GHxGvxQJsvxiVlyul+djpYMLspjA0auGUmY3RrNSrfDcyDgG2D7m39wsUJCihdcG7ryqaMlTRKxVZVl8vM78x1kTS0O9FD20KRxDT/gUGSZwGP1V5kHO8QmVBKfE6+E/v43Z/cDu3Ac33RSifL2kPPsYFkpmupQIqx2G6leUgCMzWoQefbRIh1FvOwEbT1ZjmYPkF1g35rsTgd5LTmamHj08cw/qJNo9gugydDWtk/aDohLsdCdioflI78LrKr6UrwkP6lTHzfnyOuwEX+huyb93EvWFhLaT5IdEhSfttWWRF4/u2gPWk9GpvV7s/97IK76UWC8TCB0j4Jcvv
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR08MB6857.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39850400004)(396003)(136003)(346002)(86362001)(316002)(478600001)(4326008)(8936002)(26005)(2906002)(7696005)(186003)(966005)(54906003)(33656002)(110136005)(83380400001)(9686003)(52536014)(71200400001)(66946007)(66476007)(5660300002)(55016002)(66446008)(66556008)(76116006)(8676002)(64756008)(122000001)(6506007)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KRUEWix+JTKyXsS0ZbEP+t72HKCacCwKRf4CIEZl+BdQCnoZgd2976ZK43NU?=
 =?us-ascii?Q?PK+P+QDIgoQhZks10+xQ7Kh7aUFVKmqp+lBZ7czQz3S8y49UV9/gaZJqzWdD?=
 =?us-ascii?Q?5wouF/YRWpgHiuH4ZqvvTgSL36d3+UTxige0KjONBNkeBh8E9MYWx8RQ4Knh?=
 =?us-ascii?Q?GoOSebLNYMdiFW39r7eV3o234Xe52QVLjUrA52LgUq6ijAVUWENiTJ1MYwqa?=
 =?us-ascii?Q?Lon0h/IAqDRwc0pNcAp2MOOeD2bWOIrLlO1taz8NTVFPf7o3dMD2HwxC8J5z?=
 =?us-ascii?Q?yntx7H15I5egdAElVBS1gHSRBygjpHTUthb2bUjVZIZh89L1Sli7RzEcWGur?=
 =?us-ascii?Q?ZmcllirB4mqU8VnCsA54mT+jESSrA3iuLkGm8WMDG/G3fHLgTWlfklukJSs6?=
 =?us-ascii?Q?8nIVRRQI7pscDJvMA3nmPAkp99FhPAejV5Dt0y8j8sbrGaGsxBQrvw86lfOb?=
 =?us-ascii?Q?tAJZm9F6H2qL99/+ZJbI3PbJ5zepcgzfKfnt3twa0dS+yDIZqoTAiGdx7DPb?=
 =?us-ascii?Q?v1ngnb3LVn/iMPQvHZOy+ISma79pSqKWZmTGoCiyc6fR9GchVKvCc6RPzyaw?=
 =?us-ascii?Q?yO4AgLSpOX5n4zGGeRL9e3PyQP0O/akFvabW5VsuOWIYM1GSgBSAAWtPt18P?=
 =?us-ascii?Q?paksrQq322S7npnXSwo6ADFGFfGQK10ivZPJ+p6ipT5APBBB1c9ZSJKDX9js?=
 =?us-ascii?Q?HATHu/dQAt0HJ8fNp2qsBy5AFeOsJ7REQCSsJqs9p1SZf1lCq1ZyuoM1NxQu?=
 =?us-ascii?Q?7k7wE9IVOwnIoJdkX0OHJxolQM705kccFw/G7MXhntB058ISyEc6N/ImA0vY?=
 =?us-ascii?Q?cSYAErydrVVtw1BPS7IbXfL4YhAOE8NSv5g7jfYi1aAiz7gHkM7ilIQeli8Z?=
 =?us-ascii?Q?fDsmS1xPu2Mr6PFaI5RDKzTSdltaCEY/ufLVD4dx8zz/IsCudUZ8Zma05TE8?=
 =?us-ascii?Q?LUrO8rJKAGOwXKRR1efX110MhMubD98tKZsuhYhLN+tTTIAI84vnq5UYu2dk?=
 =?us-ascii?Q?f5Gl5XDarcOi3GXImabU33OkNvoLB2OEdj3cc5WDA4hItLs2+yNtn6aKgD/R?=
 =?us-ascii?Q?ClJk4Chh+a/Rb5Y+GTHvVOAOYGEdAu/pdRml3CPa2HAEOZO2c4LlOhOjBsU6?=
 =?us-ascii?Q?7EfrzTdRdbz5B85XM8m4P+/stfMjk9L+gojuCGSXLASxzToIUnwfZOQxbLB+?=
 =?us-ascii?Q?fJg+p0d+E2kdS+lIeGqM0efPNjU74mCtcWWLciUXFiw9sW89sevhqQO6H9il?=
 =?us-ascii?Q?Ykv0cTTZUV8jiAOEJyFYaViNfngV8OL6ybHJZxB6XbNSDn/ieKhlgK+0lE/u?=
 =?us-ascii?Q?ChxdtJO8R4Ijh16btzmPCMpl?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3178
Original-Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT026.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 16fdc8ee-31b8-49c2-8b66-08d92fc481fb
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +ZcK1UNvYuK7sVzBtuexp4uUszgz992Rs9+GDQvLylHttjeu7+0oL9s+K/Q9b+1ytlFV2hAXf+mkpAzVa06cDExsmCt6SIbVo1xQmr2P42zT8wsEmcRvoSy65Xb/Pg9ZlJrLTa7cSHeoOAWAxE49WW3SgFYdZrHp+sz0u865jIgbiv5L6T+VBvHyvBWLO4Opacl4ljs2m4Zk7ys7LHR5V+fogIywz5BU3UJQPciJQQAgG1paacIzUlBwjT6xhsHe/1ENhQx5Ynp/jOBg+emiILCgZCH7hEjN44mPWfREq8WyWlRwb8QMeVNDRG7HVC1zS3VCknHkOUmb6X+AiiVAl0jD4u2ERaalBtLGZQZfT5NLzFIH/fROjlMfDRnmiqLKtN2jO7XZYXgwB+I8wwj3ThVpf3QX5aNnyEWgEf8m3+sglmEWO9dFtSK6RCey0O5pAR90tjq8xLCrm4G28kfxwzvbAQFazBHSm4gIsDbuKkQy/NLRrm0Lw/rewhqNLbuS540n1j94Uwg38Cwqfs782JzKIjF85IvI8gwcLdP4XcIimIucXxvImSfrAJbCGS0WduTN6x4M/DywRG1icnkG+/rz8FRqYXOT8/JQ9SvUXlNZpSXxONpLlfo+PfJjhArjQRSiv7WJ9RgvwqWZXb7TRkxO5zKcD50F3xWC4exJkpFgxNysG4xPdCMwFaAe7BEiGY0D7bO7/aqVzohsoMRaNDXlUfvsC+zUke4uEARyprMA59L5m1oGILKO5uoo3eI+2RUNCfFlyNMUkD7JPAtvKvXy+XhJOpm6xBA57aaHhML/O/FcLCSK5Mi+bxBR/B/v
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(39850400004)(376002)(136003)(346002)(396003)(36840700001)(46966006)(55016002)(6506007)(82310400003)(966005)(4326008)(70206006)(478600001)(36860700001)(107886003)(9686003)(86362001)(186003)(316002)(356005)(54906003)(2906002)(83380400001)(82740400003)(52536014)(8936002)(7696005)(33656002)(26005)(5660300002)(70586007)(47076005)(81166007)(110136005)(8676002)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2021 06:12:23.4577
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7edeb86c-34f6-429d-f2dd-08d92fc48aa4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT026.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6998
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I have some thoughts of using kvmtool Virtio implementation
for Xen. I copied my markdown file to this email. If you have
time, could you please help me review it?

Any feedback is welcome!

# Some thoughts on using kvmtool Virtio for Xen
## Background

Xen community is working on adding VIRTIO capability to Xen. And we're work=
ing
on VIRTIO backend of Xen. But except QEMU can support virtio-net for x86-xe=
n,
there is not any VIRTIO backend can support Xen. Because of the community's
strong voice of Out-of-QEMU, we want to find a light weight VIRTIO backend =
to
support Xen.

We have an idea of utilizing the virtio implementaton of kvmtool for Xen. A=
nd
We know there was some agreement that kvmtool won't try to be a full QEMU
alternative. So we have written two proposals in following content for
communities to discuss in public:

## Proposals
### 1. Introduce a new "dm-only" command
1. Introduce a new "dm-only" command to provide a pure device model mode. I=
n
   this mode, kvmtool only handles IO request. VM creation and initializati=
on
   will be bypassed.

    * We will rework the interface between the virtio code and the rest of
    kvmtool, to use just the minimal set of information. At the end, there
    would be MMIO accesses and shared memory that control the device model,
    so that could be abstracted to do away with any KVM specifics at all. I=
f
    this is workable, we will send the first set of patches to introduce th=
is
    interface, and adapt the existing kvmtool to it. Then later we will can
    add Xen support on top of it.

    About Xen support, we will detect the presence of Xen libraries, also
    allow people to ignore them, as kvmtoll do with optional features like
    libz or libaio.

    Idealy, we want to move all code replying on Xen libraries to a set of
    new files. In this case, thes files can only be compiled when Xen
    libraries are detected. But if we can't decouple this code completely,
    we may introduce a bit of #ifdefs to protect this code.

    If kvm or other VMM do not need "dm-only" mode. Or "dm-only" can not
    work without Xen libraries. We will make "dm-only" command depends on
    the presence of Xen libraries.

    So a normal compile (without the Xen libraries installed) would create
    a binary as close as possible to the current code, and only the people
    who having Xen libraries installed would ever generate a "dm-only"
    capable kvmtool.

### 2. Abstract kvmtool virtio implementation as a library
1. Add a kvmtool Makefile target to generate a virtio library. In this
   scenario, not just Xen, but any project else want to provide a
   userspace virtio backend service can link to this virtio libraris.
   These users would benefit from the VIRTIO implementation of kvmtool
   and will participate in improvements, upgrades, and maintenance of
   the VIRTIO libraries.

    * In this case, Xen part code will not upstream to kvmtool repo,
      it would then be natural parts of the xen repo, in xen/tools or
      maintained in other repo.

      We will have a completely separate VIRTIO backend for Xen, just
      linking to kvmtool's VIRTIO library.

    * The main changes of kvmtool would be:
        1. Still need to rework the interface between the virtio code
           and the rest of kvmtool, to abstract the whole virtio
           implementation into a library
        2. Modify current build system to add a new virtio library target.

## Reworking the interface is the common work for above proposals
**In kvmtool, one virtual device can be separated into three layers:**

- A device type layer to provide an abstract
    - Provide interface to collect and store device configuration.
        Using block device as an example, kvmtool is using disk_image to
        -  collect and store disk parameters like:
            -  backend image format: raw, qcow or block device
            -  backend block device or file image path
            -  Readonly, direct and etc
    - Provide operations to interact with real backend devices or services:
        - provide backend device operations:
            - block device operations
            - raw image operations
            - qcow image operations
- Hypervisor interfaces
    - Guest memory mapping and unmapping interfaces
    - Virtual device register interface
        - MMIO/PIO space register
        - IRQ register
    - Virtual IRQ inject interface
    - Hypervisor eventfd interface
- An implementation layer to handle guest IO request.
    - Kvmtool provides virtual devices for guest. Some virtual devices two
      kinds of implementations:
        - VIRTIO implementation
        - Real hardware emulation

For example, kvmtool console has virtio console and 8250 serial two kinds
of implementations. These implementation depends on device type parameters
to create devices, and depends on device type ops to forward data from/to
real device. And the implementation will invoke hypervisor interfaces to
map/unmap resources and notify guest.

In the current kvmtool code, the boundaries between these three layers are
relatively clear, but there are a few pieces of code that are somewhat
interleaved, for example:
- In virtio_blk__init(...) function, the code will use disk_image directly.
  This data is kvmtool specified. If we want to make VIRTIO implementation
  become hypervisor agnostic. Such kind of code should be moved to other
  place. Or we just keep code from virtio_blk__init_one(...) in virtio bloc=
k
  implementation, but keep virtio_blk__init(...) in kvmtool specified part
  code.

However, in the current VIRTIO device creation and data handling process,
the device type and hypervisor API used are both exclusive to kvmtool and
KVM. If we want to use current VIRTIO implementation for other device
models and hypervisors, it is unlikely to work properly.

So, the major work of reworking interface is decoupling VIRTIO implementati=
on
from kvmtool and KVM.

**Introduce some intermediate data structures to do decouple:**
1. Introduce intermedidate type data structures like `virtio_disk_type`,
   `virtio_net_type`, `virtio_console_type` and etc. These data structures
   will be the standard device type interfaces between virtio device
   implementation and hypervisor.  Using virtio_disk_type as an example:
    ~~~~
    struct virtio_disk_type {
        /*
         * Essential configuration for virtio block device can be got from
         * kvmtool disk_image. Other hypervisor device model also can use
         * this data structure to pass necessary parameters for creating
         * a virtio block device.
         */
        struct virtio_blk_cfg vblk_cfg;
        /*
         * Virtio block device MMIO address and IRQ line. These two members
         * are optional. If hypervisor provides allocate_mmio_space and
         * allocate_irq_line capability and device model doesn't set these
         * two fields, virtio block implementation will use hypervisor APIs
         * to allocate MMIO address and IRQ line. If these two fields are
         * configured, virtio block implementation will use them.
         */
        paddr_t addr;
        uint32_t irq;
        /*
         * In kvmtool, this ops will connect to disk_image APIs. Other
         * hypervisor device model should provide similar APIs for this
         * ops to interact with real backend device.
         */
        struct disk_type_ops {
            .read
            .write
            .flush
            .wait
            ...
        } ops;
    };
    ~~~~

2. Introduce a intermediate hypervisor data structure. This data structure
   provides a set of standard hypervisor API interfaces. In virtio
   implementation, the KVM specified APIs, like kvm_register_mmio, will not
   be invoked directly. The virtio implementation will use these interfaces
   to access hypervisor specified APIs. for example `struct vmm_impl`:
    ~~~~
    struct vmm_impl {
        /*
         * Pointer that link to real hypervisor handle like `struct kvm *kv=
m`.
         * This pointer will be passed to the vmm ops;
         */
        void *vmm;
        allocate_irq_line_fn_t(void* vmm, ...);
        allocate_mmio_space_fn_t(void* vmm, ...);
        register_mmio_fn_t(void* vmm, ...);
        map_guest_page_fn_t(void* vmm, ...);
        unmap_guest_page_fn_t(void* vmm, ...);
        virtual_irq_inject_fn_t(void* vmm, ...);
    };
    ~~~~

3. After decoupled with kvmtool, any hypervisor can use standard `vmm_impl`
   and `virtio_xxxx_type` interfaces to invoke standard virtio implementati=
on
   interfaces to create virtio devices.
    ~~~~
    /* Prepare VMM interface */
    struct vmm_impl *vmm =3D ...;
    vmm->register_mmio_fn_t =3D kvm__register_mmio;
    /* kvm__map_guset_page is a wrapper guest_flat_to_host */
    vmm->map_guest_page_fn_t =3D kvm__map_guset_page;
    ...

    /* Prepare virtio_disk_type */
    struct virtio_disk_type *vdisk_type =3D ...;
    vdisk_type->vblk_cfg.capacity =3D disk_image->size / SECTOR_SIZE;
    ...
    vdisk_type->ops->read =3D disk_image__read;
    vdisk_type->ops->write =3D disk_image__write;
    ...

    /* Invoke VIRTIO implementation API to create a virtio block device */
    virtio_blk__init_one(vmm, vdisk_type);
    ~~~~

VIRTIO block device simple flow before reworking interface:
https://drive.google.com/file/d/1k0Grd4RSuCmhKUPktHj9FRamEYrPCFkX/view?usp=
=3Dsharing
![image](https://drive.google.com/uc?export=3Dview&id=3D1k0Grd4RSuCmhKUPktH=
j9FRamEYrPCFkX)

VIRTIO block device simple flow after reworking interface:
https://drive.google.com/file/d/1rMXRvulwlRO39juWf08Wgk3G1NZtG2nL/view?usp=
=3Dsharing
![image](https://drive.google.com/uc?export=3Dview&id=3D1rMXRvulwlRO39juWf0=
8Wgk3G1NZtG2nL)


Thanks,
Wei Chen
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
