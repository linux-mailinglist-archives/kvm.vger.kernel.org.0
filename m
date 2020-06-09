Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6101F3CBE
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 15:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729713AbgFINhJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 09:37:09 -0400
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:29878 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728400AbgFINhH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Jun 2020 09:37:07 -0400
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 059DQfF0030305;
        Tue, 9 Jun 2020 06:36:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=MdfX0Kpddp/8z0r6PqIWlieilzIfMHhCKQiA/8Iotoo=;
 b=xX/F9Ghpz4qQmmV3v5jyWzcRO9IBREUEUqlWC5pD7GLpKubWa2p4puwk/LTex/qUVhdF
 WfZPudGbNO09dSBQfMNM0SMb0BLBBV6g2bOHkUNpeoeulQszSJ5AHQR8Eht3ptJOJS/S
 bIo6cX/Fh3le+aB0DTpkSfwUu00KEWzR7iXEmNvaR1RkJdlNrdD2dakRCtc5w/KgZpoq
 e8tRbNDKjvDBkTAAJyJblNx88KpblWQK5z8DSQKdrarE7aQXpL5ytBKW9PG7jVWb6l/L
 vHeq0mMzjrOjCtA4vdXhmjN4nWa/A2t/JZvSwLakmeeLat3wUPxh2BzMowPQLxSWAJNu xQ== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by mx0b-002c1b01.pphosted.com with ESMTP id 31g98jeeav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jun 2020 06:36:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ahYwq5evvbbUl7/dCHsVHmXoLlUzVZN0/U8RBCYJAJY/icF3pAXZtAsm1z6r6IUwJLnWgm7dGYUoXFnhNEjVOkcFXCsHw8fQD7Y/NbfAlEZxSlVL3UXdAcT+vMr3/etGWJb7eb/vi7ScMiwXr3du1sBJvTPZsEtdSQNd2bFe/uEf/5X2qy2c0dz405r5gi8zQAapfdxQFFIxQxng9ea5pq55T3zmfrM70P+8xFtkJxQyTEJ2kI/z0XV5ndAry2iA5MLKVHjTcMuRlRAlp6OYFPbyHZG6gLPk+lXHMHHhdif7GCf0RepLNeWNW8q4tLNs4oFBYTkBaQPvh+Ww28YHzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MdfX0Kpddp/8z0r6PqIWlieilzIfMHhCKQiA/8Iotoo=;
 b=Ggv2GO13Hat5QADTksQhT5BuKiPBKzTtJgUHRAiq/1gvuUpyB+NPNZnr8qHppnY5frzJthw+UL3WacbGyMDtwiED11X3bmT9rT210hNNVZSU/GTddIVD0lHn1HbZCmkTEf9l/uqZWSDaaztLm9Fp5ehRx6arNNoScd1VsBqajx1Rw92BV7yuEOi/yIz1JXo8esAJtG5LeOosGZExEREUHtnd5m6st+PQr2ioJA8JQyuZpKw/FsWzatRwzuo/950ji6QIP9kcJ3uWGg2LkR0Axm9WyuM3rnp+RUWn1OuvIblAbLvrfyD0RuwDPX74jSZvZ/IYs0h1N5BaI93EsnTdzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BY5PR02MB6690.namprd02.prod.outlook.com (2603:10b6:a03:213::10)
 by BY5PR02MB6820.namprd02.prod.outlook.com (2603:10b6:a03:213::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Tue, 9 Jun
 2020 13:36:14 +0000
Received: from BY5PR02MB6690.namprd02.prod.outlook.com
 ([fe80::6ceb:66bd:bb5f:179e]) by BY5PR02MB6690.namprd02.prod.outlook.com
 ([fe80::6ceb:66bd:bb5f:179e%9]) with mapi id 15.20.3066.023; Tue, 9 Jun 2020
 13:36:13 +0000
From:   Eiichi Tsukata <eiichi.tsukata@nutanix.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Franciosi <felipe@nutanix.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC PATCH] KVM: x86: Fix APIC page invalidation race
Thread-Topic: [RFC PATCH] KVM: x86: Fix APIC page invalidation race
Thread-Index: AQHWO7rKzyOSDfpNlUO9aScE6IXasajOtaaAgADGnYCAAJQaAIAAPg4A
Date:   Tue, 9 Jun 2020 13:36:13 +0000
Message-ID: <D9A42B2E-7BB1-4E70-98CD-40D295D9DB1A@nutanix.com>
References: <20200606042627.61070-1-eiichi.tsukata@nutanix.com>
 <0d9b3313-5d4c-9ef3-63e4-ba08ddbbe7a1@redhat.com>
 <7B9024C7-98D0-4940-91AE-40BCDE555C8F@nutanix.com>
 <6d2d2faf-116f-8c71-fda2-3fc052952dee@redhat.com>
In-Reply-To: <6d2d2faf-116f-8c71-fda2-3fc052952dee@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nutanix.com;
x-originating-ip: [39.110.210.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e919419-a64a-4c7c-13df-08d80c7a144a
x-ms-traffictypediagnostic: BY5PR02MB6820:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR02MB682036C5B06663115DEACD7380820@BY5PR02MB6820.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 042957ACD7
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: puI0/ENvHrevfSpP92IDleuUsaUXXb38mP/16ZmgHXHqXa1cym/jGCOsvTPlcYzyUXXPFipMTHVYIsIecWY7HAxa4PpX7JQFlJBYvAOlVDTYStjZlHoW8RrO4DsDpajd5THyzs+xoPKIJKBzaMguzla4BSq+zKgwVR9TfQAtq+bpuOdEmfUW/Lg/XKjwgoYQ350tF3UkzDE3mOxrGzb+4dTeKl8u9yFCEaZsvtzh7i7PTqIe2bG/7ktNorkbooYh0pvyupVAT7aUAFrr/cVegYZ+qnZYEdFL7uxpICSbs2U0DTU6T3dwdODNOJXN4z9ZADubGpfBnWbSIpRK6yd+ASGBY3gZNoupY9uA8PrUETtjqESyP08whIGTFE1JpG8TXp9qgPfD7F6fnyvgMfO49Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR02MB6690.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(376002)(346002)(396003)(39860400002)(366004)(478600001)(4326008)(33656002)(966005)(8676002)(44832011)(86362001)(7416002)(83380400001)(2616005)(8936002)(2906002)(6512007)(316002)(54906003)(5660300002)(76116006)(186003)(6506007)(26005)(6486002)(53546011)(66556008)(36756003)(66476007)(6916009)(71200400001)(66946007)(66446008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: V/s3Mku3px2S78lO8YklNrprvVnfEUPguB5L56aAOEYZqzcG9S1Y4DrqR8GDVKvqAeekI13+WlsM4hb7xpWBgLz6ULy9xumR5YVHDn1KCUc3q3OQcfAWFCEiF0Jx1NUZnmuepPym/qbO/lAvBIIj3aW3DHQrRn3HAbPP/J/wg4rCFrnPnbRY4iannxmUUMJS1ix/1ULPrVaS3QMi508lgMZgi0yvBZA9U8Bf1C7ciga0QkBpmtExc25gmAqjjDva4mNoh+Xr+YQWNMSitjeIbz4gFknpcbvyp21HHsUKmVkjdHQOFpG61OweoaoPrZETmmpH+4zkIbJ7ow2dYM7EkAhFuWolxmJ3vfSXIapus5TAZqgnd0quPdZEnSIuPWTnLe3ChblheAxdBzRY1m4m4o6FsCQUTd94r3SGhUGqrCYz5fvr/cNM5diocKUWP4lGaeXqperpI1VPJ13+NSokgMNLmH6NY6FBDwLOO55qQOYrivC9EUMkeerlDAUHhEyb
Content-Type: text/plain; charset="us-ascii"
Content-ID: <614DDFD98C7DE24685B5D905EF6E36D3@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e919419-a64a-4c7c-13df-08d80c7a144a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2020 13:36:13.7045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jHkkKJdpfTl+RzGqrFTA6V1XIxZFb6IXl/qL90jAIrTZc/bE7pRgV27wqMfClFF92xz41d8MmqXw2StJ5CxqowHxCOZtUlsJgzKHvNA8mlo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6820
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-09_06:2020-06-09,2020-06-09 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Jun 9, 2020, at 18:54, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
>=20
> No need to resend, the patch is good.  Here is my take on the commit mess=
age:

Thank you Paolo! Your commit message is much clearer.
I really appreciate your great job.

Best

Eiichi

>=20
>    Commit b1394e745b94 ("KVM: x86: fix APIC page invalidation") tried
>    to fix inappropriate APIC page invalidation by re-introducing arch
>    specific kvm_arch_mmu_notifier_invalidate_range() and calling it from
>    kvm_mmu_notifier_invalidate_range_start. However, the patch left a
>    possible race where the VMCS APIC address cache is updated *before*
>    it is unmapped:
>=20
>      (Invalidator) kvm_mmu_notifier_invalidate_range_start()
>      (Invalidator) kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOA=
D)
>      (KVM VCPU) vcpu_enter_guest()
>      (KVM VCPU) kvm_vcpu_reload_apic_access_page()
>      (Invalidator) actually unmap page
>=20
>    Because of the above race, there can be a mismatch between the
>    host physical address stored in the APIC_ACCESS_PAGE VMCS field and
>    the host physical address stored in the EPT entry for the APIC GPA
>    (0xfee0000).  When this happens, the processor will not trap APIC
>    accesses, and will instead show the raw contents of the APIC-access pa=
ge.
>    Because Windows OS periodically checks for unexpected modifications to
>    the LAPIC register, this will show up as a BSOD crash with BugCheck
>    CRITICAL_STRUCTURE_CORRUPTION (109) we are currently seeing in
>    https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__bugzilla.redhat=
.com_show-5Fbug.cgi-3Fid-3D1751017&d=3DDwIDaQ&c=3Ds883GpUCOChKOHiocYtGcg&r=
=3Ddy01Dr4Ly8mhvnUdx1pZhhT1bkq4h9z5aVWu3paoZtk&m=3Dyo6pYK4bnrvDLz_RwGyvwtJE=
Y6oWkg-9XGlbPBq1B2g&s=3D7tKkV92x4mCNLQ7miJIanMVqokYNJdjrcK4Rqqb_h7s&e=3D .
>=20
>    The root cause of the issue is that kvm_arch_mmu_notifier_invalidate_r=
ange()
>    cannot guarantee that no additional references are taken to the pages =
in
>    the range before kvm_mmu_notifier_invalidate_range_end().  Fortunately=
,
>    this case is supported by the MMU notifier API, as documented in
>    include/linux/mmu_notifier.h:
>=20
>             * If the subsystem
>             * can't guarantee that no additional references are taken to
>             * the pages in the range, it has to implement the
>             * invalidate_range() notifier to remove any references taken
>             * after invalidate_range_start().
>=20
>    The fix therefore is to reload the APIC-access page field in the VMCS
>    from kvm_mmu_notifier_invalidate_range() instead of ..._range_start().
>=20
> Thanks,
>=20
> Paolo

