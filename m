Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AABEF259F06
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 21:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgIATN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 15:13:28 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:39005 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728130AbgIATN1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 15:13:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1598987606; x=1630523606;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=w7ftULaPpfhBrTyIGjw24JWJqunt94vLzHsPBbaDg1s=;
  b=Yi2x1RwGjqWDCWDWfo4R7W4KxbwcjCgNc1uA8XSOCgSnwJJ3WNp0TPNx
   AmFt8nTAlOR+Udyi6E/Wra2hStKViYnCOTESPxmCUCTcACl9hjuyTINhF
   eOzFFbB70efAlleI9fKAwyOL+sKdsRFnGZp00M0v3Qk/6cMNEpjHhI13H
   A=;
X-IronPort-AV: E=Sophos;i="5.76,380,1592870400"; 
   d="scan'208";a="51482452"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 01 Sep 2020 19:13:19 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id 2AA89A2535;
        Tue,  1 Sep 2020 19:13:15 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Sep 2020 19:13:15 +0000
Received: from freeip.amazon.com (10.43.160.229) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Sep 2020 19:13:12 +0000
Subject: Re: [PATCH v3 02/12] KVM: x86: Introduce allow list for MSR emulation
To:     Dan Carpenter <dan.carpenter@oracle.com>, <kbuild@lists.01.org>,
        "Aaron Lewis" <aaronlewis@google.com>, <jmattson@google.com>
CC:     <lkp@intel.com>, <kbuild-all@lists.01.org>, <pshier@google.com>,
        <oupton@google.com>, <kvm@vger.kernel.org>,
        KarimAllah Ahmed <karahmed@amazon.de>
References: <20200831103933.GF8299@kadam>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <79dd5f72-a332-a657-674d-f3a9c94146f1@amazon.com>
Date:   Tue, 1 Sep 2020 21:13:10 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.0
MIME-Version: 1.0
In-Reply-To: <20200831103933.GF8299@kadam>
Content-Language: en-US
X-Originating-IP: [10.43.160.229]
X-ClientProxiedBy: EX13D35UWB002.ant.amazon.com (10.43.161.154) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 31.08.20 12:39, Dan Carpenter wrote:
> =

> Hi Aaron,
> =

> url:    https://github.com/0day-ci/linux/commits/Aaron-Lewis/Allow-usersp=
ace-to-manage-MSRs/20200819-051903
> base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git linux-next
> config: x86_64-randconfig-m001-20200827 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> =

> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks a bunch for looking at this! I'd squash in the change with the =

actual patch as it's tiny, so I'm not sure how attribution would work in =

that case.

> =

> smatch warnings:
> arch/x86/kvm/x86.c:5248 kvm_vm_ioctl_add_msr_allowlist() error: 'bitmap' =
dereferencing possible ERR_PTR()
> =

> # https://github.com/0day-ci/linux/commit/107c87325cf461b7b1bd07bb6ddbaf8=
08a8d8a2a
> git remote add linux-review https://github.com/0day-ci/linux
> git fetch --no-tags linux-review Aaron-Lewis/Allow-userspace-to-manage-MS=
Rs/20200819-051903
> git checkout 107c87325cf461b7b1bd07bb6ddbaf808a8d8a2a
> vim +/bitmap +5248 arch/x86/kvm/x86.c
> =

> 107c87325cf461 Aaron Lewis 2020-08-18  5181  static int kvm_vm_ioctl_add_=
msr_allowlist(struct kvm *kvm, void __user *argp)
> 107c87325cf461 Aaron Lewis 2020-08-18  5182  {
> 107c87325cf461 Aaron Lewis 2020-08-18  5183     struct msr_bitmap_range *=
ranges =3D kvm->arch.msr_allowlist_ranges;
> 107c87325cf461 Aaron Lewis 2020-08-18  5184     struct kvm_msr_allowlist =
__user *user_msr_allowlist =3D argp;
> 107c87325cf461 Aaron Lewis 2020-08-18  5185     struct msr_bitmap_range r=
ange;
> 107c87325cf461 Aaron Lewis 2020-08-18  5186     struct kvm_msr_allowlist =
kernel_msr_allowlist;
> 107c87325cf461 Aaron Lewis 2020-08-18  5187     unsigned long *bitmap =3D=
 NULL;
> 107c87325cf461 Aaron Lewis 2020-08-18  5188     size_t bitmap_size;
> 107c87325cf461 Aaron Lewis 2020-08-18  5189     int r =3D 0;
> 107c87325cf461 Aaron Lewis 2020-08-18  5190
> 107c87325cf461 Aaron Lewis 2020-08-18  5191     if (copy_from_user(&kerne=
l_msr_allowlist, user_msr_allowlist,
> 107c87325cf461 Aaron Lewis 2020-08-18  5192                        sizeof=
(kernel_msr_allowlist))) {
> 107c87325cf461 Aaron Lewis 2020-08-18  5193             r =3D -EFAULT;
> 107c87325cf461 Aaron Lewis 2020-08-18  5194             goto out;
> 107c87325cf461 Aaron Lewis 2020-08-18  5195     }
> 107c87325cf461 Aaron Lewis 2020-08-18  5196
> 107c87325cf461 Aaron Lewis 2020-08-18  5197     bitmap_size =3D BITS_TO_L=
ONGS(kernel_msr_allowlist.nmsrs) * sizeof(long);
>                                                                ^^^^^^^^^^=
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^n
> On 32 bit systems the BITS_TO_LONGS() can integer overflow if
> kernel_msr_allowlist.nmsrs is larger than ULONG_MAX - bits_per_long.  In
> that case bitmap_size is zero.

Nice catch! It should be enough to ...

> =

> 107c87325cf461 Aaron Lewis 2020-08-18  5198     if (bitmap_size > KVM_MSR=
_ALLOWLIST_MAX_LEN) {

... add a check for !bitmap_size here as well then, right?

> 107c87325cf461 Aaron Lewis 2020-08-18  5199             r =3D -EINVAL;
> 107c87325cf461 Aaron Lewis 2020-08-18  5200             goto out;
> 107c87325cf461 Aaron Lewis 2020-08-18  5201     }
> 107c87325cf461 Aaron Lewis 2020-08-18  5202
> 107c87325cf461 Aaron Lewis 2020-08-18  5203     bitmap =3D memdup_user(us=
er_msr_allowlist->bitmap, bitmap_size);
> 107c87325cf461 Aaron Lewis 2020-08-18  5204     if (IS_ERR(bitmap)) {
> 107c87325cf461 Aaron Lewis 2020-08-18  5205             r =3D PTR_ERR(bit=
map);
> 107c87325cf461 Aaron Lewis 2020-08-18  5206             goto out;
>                                                          ^^^^^^^^
> "out" is always a vague label name.  It's better style to return
> directly instead of doing a complicated no-op.
> =

>          if (IS_ERR(bitmap))
>                  return PTR_ERR(bitmap);

I agree 100% :). In fact, I agree so much that I already did change it =

for v6 last week, just did not send it out yet.

> =

> 107c87325cf461 Aaron Lewis 2020-08-18  5207     }
> 107c87325cf461 Aaron Lewis 2020-08-18  5208
> 107c87325cf461 Aaron Lewis 2020-08-18  5209     range =3D (struct msr_bit=
map_range) {
> 107c87325cf461 Aaron Lewis 2020-08-18  5210             .flags =3D kernel=
_msr_allowlist.flags,
> 107c87325cf461 Aaron Lewis 2020-08-18  5211             .base =3D kernel_=
msr_allowlist.base,
> 107c87325cf461 Aaron Lewis 2020-08-18  5212             .nmsrs =3D kernel=
_msr_allowlist.nmsrs,
> 107c87325cf461 Aaron Lewis 2020-08-18  5213             .bitmap =3D bitma=
p,
> =

> In case of overflow then "bitmap" is 0x16 and .nmsrs is a very high
> number.

The overflow case should disappear with the additional check above, right?


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



