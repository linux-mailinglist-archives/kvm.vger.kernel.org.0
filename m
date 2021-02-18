Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C1231EE78
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 19:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbhBRSiA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 13:38:00 -0500
Received: from mail-dm3nam07on2040.outbound.protection.outlook.com ([40.107.95.40]:41089
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230466AbhBRSdl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 13:33:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I5cQUbggejwszn+Z4qnZ0kxeE/1racJw/zUfQ4EchZ/U0VAc2uEAjMzbHn1ug9nS6vuR2XURWN3iv80W8ojaUNeu5qI305Ud4SJaUf4wX7j1jXTLsEcH/PZV7GBmr49fN6oXEWmP/JcFuSyNSYEy6foO1ufT5tJABEEibZd12T91Dcxko76loKfbHY3nuHi7EaOm+jGk5BPV7ZVpdgHN17Lu2iX8RvManW6QzGhk3bc0odpLN7HytDESNRzkxYyYs2zVLejCPJjL+CIiQh2Pt0tsqub7FV0bUTMW9EW45nZsrgRqu8oOHsV1JQpvpZd9Zi0mrDtZa7VeNZDG2MAa8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fwmkzgSO0Jf6jF8gMmvNkkow2Ks+XsSLz70JkeRxqWw=;
 b=XFyd5OLChBRlr88HSM2wZ2rJmLPCl2YnwPT0MwblOCExkK1mQB2hjmYKySlavthi00Z165155i98CNE1gAKNNDgoYbXEh4sCGfpxlef9jBH2aaZMqE/hjCgn/EIbZk3Mkf3+IGgyKksOlby0aBNYt2iOUGj62kNPVI5P3QhrGjyFTIbpCTOmwZuNDBz0SGkDXzXvCDi39zKXGlzwtkVDWY8Wu66xyJZdlAOoXwe24ykWZEAygT/vzkzdHKrSgYbpuTx9gcXYQabquQ9tYQqxVrZ/ykY6CVl7YpOFq6ZsDCr8UJcUH4dA5rFaPwfLlouokkfh9iQTctqHSuR9EVKMQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fwmkzgSO0Jf6jF8gMmvNkkow2Ks+XsSLz70JkeRxqWw=;
 b=fVWqdk6qM2+m43W2Gc7DnmpoNVDx/6SoO838Vo9jcPO7sKLYNBcFIU3Koa1R8nGpUQ6z//aY3co95heXvP0GUQ2cSMUFtILxJXe1kMT7O/s4LXowC66fh1ldndmULG9XdnK6Ju+SNHVbJGIIeYGxVK/FL0TZxWoy4SnQEff+W3M=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4495.namprd12.prod.outlook.com (2603:10b6:806:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.38; Thu, 18 Feb
 2021 18:32:47 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3846.038; Thu, 18 Feb 2021
 18:32:47 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>, "bp@suse.de" <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "srutherford@google.com" <srutherford@google.com>,
        "venu.busireddy@oracle.com" <venu.busireddy@oracle.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>
Subject: RE: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST
 ioctl
Thread-Topic: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST
 ioctl
Thread-Index: AQHW+o4w4C5VGgubRkqZlElkExidF6pbnD+AgAK18QA=
Date:   Thu, 18 Feb 2021 18:32:47 +0000
Message-ID: <SN6PR12MB27672FF8358D122EDD8CC0188E859@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1612398155.git.ashish.kalra@amd.com>
 <7266edd714add8ec9d7f63eddfc9bbd4d789c213.1612398155.git.ashish.kalra@amd.com>
 <YCxrV4u98ZQtInOE@google.com>
In-Reply-To: <YCxrV4u98ZQtInOE@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-02-18T18:32:43Z;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=7fbeec79-ee9f-4ef7-a121-59b91dbbff8f;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=1
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
x-originating-ip: [183.83.213.136]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 134d9b1f-5642-42e4-adc6-08d8d43b96db
x-ms-traffictypediagnostic: SA0PR12MB4495:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR12MB4495A0A9810CB3FE290603FD8E859@SA0PR12MB4495.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vDdPp1ugSWfvgVpWUs9qnu7sEzFMY/EYlgVl6zx9UCoBlHklvBztSqHEMBbqGyt/NM08B0uZqcFUDRRAhVwim6NfT0rzPXHsxg7UcWPSAqVgHt0ybM5ARkGwAVU3WDCi89ujwGdcbFuIYdS4097MF/kDxcb3YEhdipSv8QDr8C4NcoMZBynl9vUU/n1jcRXvZPxTFWKzK5Ng9YIr242t0W+/maFHYwInBKEYden6tkjjAhHanZ9IrlaX75RbERMSXnEdGMmEC8eMwJl26YuwKbqzZlIzkev8+ghR0tuBUHGg7aRSDEJNksBpl5Hi77ettuZZmJPqJZ3fqvHeXPlNxyIh5pvkEXGnCBUznaURZ9kLxkxW7sIu1vQmFABHXS0Ats+xTVaPbBkvbvKs69fdRO5G7FnW28DnGuJlUMzQ/snu41joBpvLvX889urH2xW8KNHA67ITflyPxRUBgvMsgZuYerlRPo5FfQVYoxQc9tKpvzQBhulhdoQy3FYaR2AZ2gLK87J+lkgfkKQFXJF6RA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(76116006)(26005)(54906003)(64756008)(9686003)(8676002)(6506007)(6916009)(186003)(4326008)(66476007)(66446008)(66556008)(55016002)(5660300002)(66946007)(7696005)(71200400001)(86362001)(52536014)(83380400001)(8936002)(478600001)(316002)(33656002)(2906002)(7416002)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?q7IhOUTbaMKVd+38VEk6US+CmakRo7SOuUeuPOckBvK8FDGmxmm9t4ZaAO2m?=
 =?us-ascii?Q?EJ1+jmiA7C6DSeDIKOP6OPUu/zOCpy0PNYYEx75SH346JHnr/33KQbcjnPp2?=
 =?us-ascii?Q?DxMp7kFnvlZWGyNCqtfFHi7T+jMZqCFH+w3J4iqKKr4yu4Mz7GrctoT9NZXv?=
 =?us-ascii?Q?A/6BmIKPHxqXmx36aPa3B5i0ksDh0PI3l0gTXVsX7Koh/OJY7KNbIJuDcVny?=
 =?us-ascii?Q?azIwBN88kZlj+QlDZWOxayRukcdB+u+dKM2pfhOENPUXcCLUy5QR5RC6QrT3?=
 =?us-ascii?Q?ACZTCE//divjCCfEvBWRNeSzQ5C84XGuer473mlq+0lYZ+2ZXOl7hJhEdLvH?=
 =?us-ascii?Q?EL8d23t05od8rG3KcsmlRUK9nt65ukBjGV4lWNYSu8FyX9YiktOH5SQHwN/d?=
 =?us-ascii?Q?QHi3jTTJJMq8fEi5dyU7+rmQ5BoJ/lutoI/6FHQB0zgVoMJy4hYRV6Kh/rOc?=
 =?us-ascii?Q?HCdc3TKV4b6bqc073Hh/XyX6PLoK4Lqo+GU4jSGnMGR7at3a84bc1cLQchUQ?=
 =?us-ascii?Q?o8bM7diZm5JP1YHDjFSBgE54bH1ERGcaM9lSuTf8o8WrFNKeWrdJ6EBGHEug?=
 =?us-ascii?Q?dM2VUzX26ojH94tLwp9SGTgu2pzLk5m7qWGB8eWlpHQBfMaRJvGbSmGYH2mr?=
 =?us-ascii?Q?4BozTWfrVPDlQMmK7QU/FLF/cu2XkOXS07ZF41Gd5frBRCHWIFCZ7fn3JD4G?=
 =?us-ascii?Q?M5M7/K1IuTbZSR/RahmDEvRZllM+MvOcKgWEyLDK378iXL9dxJueEY55Byp3?=
 =?us-ascii?Q?xgQGk2mo0ilbAyGwGbrJ1k+R5web1qWZ73wFqg34W60t703oH8Bgfr5znCer?=
 =?us-ascii?Q?aJ19PQ9XCBizg55R5mCVWMjr8/Rra06vK/SG+6b8hUtJctMHODm2b0m3ck01?=
 =?us-ascii?Q?3SCWSVfZKNSAw2NlngrT8A1vV5zWQkICYk5C6GMoj3/3peJir3VfBBGgQNDK?=
 =?us-ascii?Q?RF/hJpM6CJH9gVZ7X+ZO4Opin5P5/RlTx+hTYxHOsR4lOraYjRZzguHugdsu?=
 =?us-ascii?Q?4qVUcdfmnqZ2upqfmX36Tvq27mh+pRUbi/y6MutP0UEQM9MipnT3pdE1Polp?=
 =?us-ascii?Q?CXCStmgqD5rV0Iqg8LTOFNMluLtBh1xb0IUNkYWvP12J8GJMUQJJK31irjbN?=
 =?us-ascii?Q?AOIG1qMJHmiH8fQ+9B1LQft7F3vqedArLvA25m/9pd88W8tRTLj7jx6jUBPp?=
 =?us-ascii?Q?HgBEmGF0ljQdD/AYG29L72jYhhE88Ytut2IaGdDbkHMPIjUEY+o87pW8/nFn?=
 =?us-ascii?Q?gAXZYFTjUvPbZ+fYZitOoclwpDyUHPCDv6EB+1mWeAlO7jTDNaybDcZSYK88?=
 =?us-ascii?Q?kEZIn/fdXci2XJ9hkBBdxMaK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 134d9b1f-5642-42e4-adc6-08d8d43b96db
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2021 18:32:47.1273
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mOIGgZB2YinrG0Zx3EgxFHyyWogrpPRCxR8DIXz8rN/OPpTwu0N1p/drZOS8X1IWHdRkwukfPBZ92UU6yLMYnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4495
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Public Use]


-----Original Message-----
From: Sean Christopherson <seanjc@google.com>=20
Sent: Tuesday, February 16, 2021 7:03 PM
To: Kalra, Ashish <Ashish.Kalra@amd.com>
Cc: pbonzini@redhat.com; tglx@linutronix.de; mingo@redhat.com; hpa@zytor.co=
m; rkrcmar@redhat.com; joro@8bytes.org; bp@suse.de; Lendacky, Thomas <Thoma=
s.Lendacky@amd.com>; x86@kernel.org; kvm@vger.kernel.org; linux-kernel@vger=
.kernel.org; srutherford@google.com; venu.busireddy@oracle.com; Singh, Brij=
esh <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIS=
T ioctl

On Thu, Feb 04, 2021, Ashish Kalra wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
>=20
> The ioctl is used to retrieve a guest's shared pages list.

>What's the performance hit to boot time if KVM_HC_PAGE_ENC_STATUS is passe=
d through to userspace?  That way, userspace could manage the set of pages =
>in whatever data structure they want, and these get/set ioctls go away.

I will be more concerned about performance hit during guest DMA I/O if the =
page encryption status hypercalls are passed through to user-space,=20
a lot of guest DMA I/O dynamically sets up pages for encryption and then fl=
ips them at DMA completion, so guest I/O will surely take a performance=20
hit with this pass-through stuff.

Thanks,
Ashish
