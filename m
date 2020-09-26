Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1A12798A8
	for <lists+kvm@lfdr.de>; Sat, 26 Sep 2020 13:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgIZLEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Sep 2020 07:04:38 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:53341 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgIZLEi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Sep 2020 07:04:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1601118278; x=1632654278;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=4nPxsafI4gUaX7co9XDI+/wU0/2eG+RrvMXq46svhS4=;
  b=Z4IenhHOnQkE3ufntK/P5bL2Y6+my+B3Vse2XOwqkRu1grqYilb5OYfQ
   r3Z6dpljiWauNZKoFjhKkxhrnIs0XftwsO8lJ8rUypk17bZhrsGshgIir
   RyXDlYaaN5eY3Oe6yxdXmF/21RrqpnP7TfuAp0KdhCiCV8/Y6Uix1yS1m
   M=;
X-IronPort-AV: E=Sophos;i="5.77,305,1596499200"; 
   d="scan'208";a="56447029"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 26 Sep 2020 11:04:34 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id D276DA074A;
        Sat, 26 Sep 2020 11:04:32 +0000 (UTC)
Received: from EX13D20UWC002.ant.amazon.com (10.43.162.163) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 26 Sep 2020 11:04:31 +0000
Received: from Alexanders-MacBook-Air.local (10.43.162.221) by
 EX13D20UWC002.ant.amazon.com (10.43.162.163) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 26 Sep 2020 11:04:28 +0000
Subject: Re: [kvm:queue 145/149] arch/x86/kvm/vmx/vmx.c:6696:17: warning:
 variable 'msr_bitmap' set but not used
To:     kernel test robot <lkp@intel.com>,
        Aaron Lewis <aaronlewis@google.com>
CC:     <kbuild-all@lists.01.org>, <kvm@vger.kernel.org>,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>
References: <202009260810.BvX8ppjr%lkp@intel.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <aae6232e-d531-0cb3-a6a9-6612b3b2ca7a@amazon.com>
Date:   Sat, 26 Sep 2020 13:04:23 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <202009260810.BvX8ppjr%lkp@intel.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.221]
X-ClientProxiedBy: EX13D14UWB004.ant.amazon.com (10.43.161.137) To
 EX13D20UWC002.ant.amazon.com (10.43.162.163)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On 26.09.20 02:40, kernel test robot wrote:
> =

> tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
> head:   8a0eda195bff0e494deadd0b2795b914a74c2650
> commit: a804ea48d4536bdc01b201564cd24da89c51d36a [145/149] KVM: x86: Prep=
are MSR bitmaps for userspace tracked MSRs
> config: i386-allyesconfig (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> reproduce (this is a W=3D1 build):
>          # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=3Da=
804ea48d4536bdc01b201564cd24da89c51d36a
>          git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.g=
it
>          git fetch --no-tags kvm queue
>          git checkout a804ea48d4536bdc01b201564cd24da89c51d36a
>          # save the attached .config to linux build tree
>          make W=3D1 ARCH=3Di386
> =

> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> =

> All warnings (new ones prefixed by >>):
> =

>     arch/x86/kvm/vmx/vmx.c: In function 'vmx_create_vcpu':
>>> arch/x86/kvm/vmx/vmx.c:6696:17: warning: variable 'msr_bitmap' set but =
not used [-Wunused-but-set-variable]
>      6696 |  unsigned long *msr_bitmap;
>           |                 ^~~~~~~~~~


Can you please squash the following (probably completely mangled) patch =

in with the commit "KVM: x86: Prepare MSR bitmaps for userspace tracked =

MSRs"?

Sorry I didn't catch this in my compile tests, my gcc didn't warn :(.


Thanks!

Alex


diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4551a7e80ebc..3570ce9bda4b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6809,7 +6809,6 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
  static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
  {
  	struct vcpu_vmx *vmx;
-	unsigned long *msr_bitmap;
  	int i, cpu, err;

  	BUILD_BUG_ON(offsetof(struct vcpu_vmx, vcpu) !=3D 0);
@@ -6869,7 +6868,6 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
  	bitmap_fill(vmx->shadow_msr_intercept.read, =

MAX_POSSIBLE_PASSTHROUGH_MSRS);
  	bitmap_fill(vmx->shadow_msr_intercept.write, =

MAX_POSSIBLE_PASSTHROUGH_MSRS);

-	msr_bitmap =3D vmx->vmcs01.msr_bitmap;
  	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_TSC, MSR_TYPE_R);
  	vmx_disable_intercept_for_msr(vcpu, MSR_FS_BASE, MSR_TYPE_RW);
  	vmx_disable_intercept_for_msr(vcpu, MSR_GS_BASE, MSR_TYPE_RW);



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



