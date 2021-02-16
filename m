Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89EA31C8B7
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 11:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhBPKZc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 16 Feb 2021 05:25:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:35150 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230183AbhBPKY5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 05:24:57 -0500
IronPort-SDR: yabTUN4RglwzpiUJE2H0GA4n1CIQUPsc8zF+27kmKUYCaGcRw6AKVFZZfy9oLpX9dzg1YA+7Bu
 rsEhiY6JezWQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="202040179"
X-IronPort-AV: E=Sophos;i="5.81,183,1610438400"; 
   d="scan'208";a="202040179"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2021 02:24:08 -0800
IronPort-SDR: UqVNwgAROrWR4doHzyBnibw5mprZhb/MckK8GC9iAcRIPo3ObOVnSDx+0+ycNctw44YXeCglce
 rxWhQklb8+yA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,183,1610438400"; 
   d="scan'208";a="366411705"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 16 Feb 2021 02:24:08 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Feb 2021 02:24:07 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Feb 2021 02:24:07 -0800
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15]) by
 ORSMSX602.amr.corp.intel.com ([10.22.229.15]) with mapi id 15.01.2106.002;
 Tue, 16 Feb 2021 02:24:07 -0800
From:   "Huang, Kai" <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "b.thiel@posteo.de" <b.thiel@posteo.de>
Subject: RE: [RFC PATCH v5 06/26] x86/cpu/intel: Allow SGX virtualization
 without Launch Control support
Thread-Topic: [RFC PATCH v5 06/26] x86/cpu/intel: Allow SGX virtualization
 without Launch Control support
Thread-Index: AQHXAgqLyQlO6VDl10euDf/K0SnZy6palUwA//+mseCAAMPNgP//jUMg
Date:   Tue, 16 Feb 2021 10:24:06 +0000
Message-ID: <6875a6542c534a4fbe8dd1c17fd077a5@intel.com>
References: <cover.1613221549.git.kai.huang@intel.com>
 <82c304d6f4e8ebfa9b35d1be74360a5004179c5f.1613221549.git.kai.huang@intel.com>
 <YCsq0uFdzwLrFCMW@kernel.org> <af4798077c93450e8e30dddbc7c650d0@intel.com>
 <YCuEHJ7a2HLG6jk/@kernel.org>
In-Reply-To: <YCuEHJ7a2HLG6jk/@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > >
> > > > +	enable_vmx = cpu_has(c, X86_FEATURE_VMX) &&
> > > > +		     IS_ENABLED(CONFIG_KVM_INTEL);
> > >
> > > It's less than 100 characters:
> >
> > Just carious, shouldn't be 80 characters to wrap a new line, instead of 100?
> 
> Try with checkpatch.pl.

Checkpatch.pl has default value 100, but it can be overwritten. I found below document explicitly said 80 should be the length:

https://www.kernel.org/doc/html/v5.11-rc7/process/coding-style.html

2) Breaking long lines and strings

Coding style is all about readability and maintainability using commonly available tools.

The preferred limit on the length of a single line is 80 columns.

Statements longer than 80 columns should be broken into sensible chunks, unless exceeding 80 columns significantly increases readability and does not hide information.

[...]

> > > >  update_sgx:
> > > > -	if (!(msr & FEAT_CTL_SGX_ENABLED) ||
> > > > -	    !(msr & FEAT_CTL_SGX_LC_ENABLED) || !enable_sgx) {
> > > > -		if (enable_sgx)
> > > > -			pr_err_once("SGX disabled by BIOS\n");
> > > > +	if (!(msr & FEAT_CTL_SGX_ENABLED)) {
> > > > +		if (enable_sgx_kvm || enable_sgx_driver)
> > > > +			pr_err_once("SGX disabled by BIOS.\n");
> > > >  		clear_cpu_cap(c, X86_FEATURE_SGX);
> > >
> > > Empty line before return statement.
> >
> > It's just two statements inside the if() {} statement. Putting a new line here is
> too sparse IMHO.
> >
> > I'd like to hear more.
> 
> This was a common review comment in original SGX series, so I'm sticking to the
> pattern.

Well if you insist, I can do that. 

But I am not that convinced. In fact, I also believe that in most cases, having empty line before 'return' is good practice, for instance, when 'return' is the very last statement in the function.

I am also glad to do it if it is a x86 patch convention that we even need to put a new empty line when there are only very few statements inside if() {}. However it seems it is not the case.

For example, I just did a search in SGX driver code, and below examples all DONOT have empty line before return (and I don't think I captured them all):

sgx/driver.c:

static int sgx_release(struct inode *inode, struct file *file)
{
        ......
        kref_put(&encl->refcount, sgx_encl_release);
        return 0;
}

sgx/ioctl.c: 

static struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl)
{
        ......
                va_page->epc_page = sgx_alloc_va_page();
                if (IS_ERR(va_page->epc_page)) {
                        err = ERR_CAST(va_page->epc_page);
                        kfree(va_page);
                        return err;
                }

                WARN_ON_ONCE(encl->page_cnt % SGX_VA_SLOT_COUNT);
        }
        encl->page_cnt++;
        return va_page;
}

static long sgx_ioc_enclave_create(struct sgx_encl *encl, void __user *arg)
{
        ......
        kfree(secs);
        return ret;
}

static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
                             unsigned long offset, struct sgx_secinfo *secinfo,
                             unsigned long flags)
{
        ......
        epc_page = sgx_alloc_epc_page(encl_page, true);
        if (IS_ERR(epc_page)) {
                kfree(encl_page);
                return PTR_ERR(epc_page);
        }
        ......
        sgx_mark_page_reclaimable(encl_page->epc_page);
        mutex_unlock(&encl->lock);
        mmap_read_unlock(current->mm);
        return ret;

        ......
}

And in cpu/feat_ctl.c:

void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
{
        ......
        if (rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr)) {
                clear_cpu_cap(c, X86_FEATURE_VMX);
                clear_sgx_caps();
                return;
        }
        ......
}
