Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED7E81012E7
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 06:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfKSFRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 00:17:44 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:41394 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfKSFRo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 00:17:44 -0500
Received: by mail-pj1-f67.google.com with SMTP id gc1so2215996pjb.8
        for <kvm@vger.kernel.org>; Mon, 18 Nov 2019 21:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ahYUK8Dgd6YlkJZ+iTKYSXX0s0UmVDB0H9isngU6bnc=;
        b=ilB97vDsSj6QSnpltRb4oStbHmrAscE5Ov4i6WbF+TAmJLgWf+yP8EWa9teedPBdTL
         9Z1djuTAb510DBGumiMfvdDi6ESq3vWeluRp6XJSLH6GDMhPxKAWBnlRBjpmWg/xRlaV
         k+1wB8n0KBkihZLmw3/bH7fEKPCs0ezDyg47b6YFq8TUmrNAR8Q09snHvOGqA8mQYzFW
         mhWkq7s3n2vciF+4FzB1G/q69n+g7WJQVm19FOAHt8PDEqC/q6yP8CjH0lmWYVs+t2mQ
         Zz9OHDbbx+HPb+M9C75IcyRgSUTvOBwx4n2xcKEBvZ7gKpsbLs5bY+GahouPrAW8EGEP
         Q+Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ahYUK8Dgd6YlkJZ+iTKYSXX0s0UmVDB0H9isngU6bnc=;
        b=onHDL3B6HD9GXu/5yw7Iz4NsEa3mXXQFXclgGbwjndc5ZJVS8uqqPwULDrBGjiqLMH
         jFjV5k0oDGUpWUU/iFwQnCT/dYkp36t4rnUd4D8zJ4ySQNJvHNwMFBm9/AjGrLRMIFjo
         3qTnzrpOffVE1ImbWYBkKysalzn0x+8uYoZiF43E+Yzy4UkwimHvwLuHZ5a4bDBMhGCE
         /AMR+pu3s9A+jGshjSf0INXMw3VVYkt9EHdQXJc6oWQZ0RSPQC0OJFXdbf0PvY03whvL
         7816G1VYnMy3f24TszVd3+MRBFOF7UbNYJn3sX0VqAUd7jd3w9/1kUWAAZqTO3gNVKbD
         phyg==
X-Gm-Message-State: APjAAAXYelytGrOnWP2wKCS4DiuZFMTIabs2OrnMhiVEUUuEmGrbAFLr
        3AhfcU3yXVaJ0JKJW9NeH9N4GQ==
X-Google-Smtp-Source: APXvYqyx60heTq2BUc2FObpDS6esgtf4UWflyBXNmynM8MMye3cmfZxGnvH7vj932qjG+bnfbLg95A==
X-Received: by 2002:a17:90a:3522:: with SMTP id q31mr3823035pjb.18.1574140662655;
        Mon, 18 Nov 2019 21:17:42 -0800 (PST)
Received: from google.com ([2620:15c:100:202:d78:d09d:ec00:5fa7])
        by smtp.gmail.com with ESMTPSA id r22sm25980004pfg.54.2019.11.18.21.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 21:17:41 -0800 (PST)
Date:   Mon, 18 Nov 2019 21:17:38 -0800
From:   Oliver Upton <oupton@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v5 0/8] KVM: nVMX: Add full nested support for "load
 IA32_PERF_GLOBAL_CTRL" VM-{Entry,Exit} control
Message-ID: <20191119051738.GA2386@google.com>
References: <20191114001722.173836-1-oupton@google.com>
 <828732bd-4b22-6ae8-7dd9-a8ec54c927ec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <828732bd-4b22-6ae8-7dd9-a8ec54c927ec@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 15, 2019 at 01:19:46PM +0100, Paolo Bonzini wrote:
> On 14/11/19 01:17, Oliver Upton wrote:
> > [v1] https://lore.kernel.org/r/20190828234134.132704-1-oupton@google.com
> > [v2] https://lore.kernel.org/r/20190903213044.168494-1-oupton@google.com
> > [v3] https://lore.kernel.org/r/20190903215801.183193-1-oupton@google.com
> > [v4] https://lore.kernel.org/r/20190906210313.128316-1-oupton@google.com
> > 
> > v1 => v2:
> >  - Add Krish's Co-developed-by and Signed-off-by tags.
> >  - Fix minor nit to kvm-unit-tests to use 'host' local variable
> >    throughout test_load_pgc()
> >  - Teach guest_state_test_main() to check guest state from within nested
> >    VM
> >  - Update proposed tests to use guest/host state checks, wherein the
> >    value is checked from MSR_CORE_PERF_GLOBAL_CTRL.
> >  - Changelog line wrapping
> > 
> > v2 => v3:
> >  - Remove the value unchanged condition from
> >    kvm_is_valid_perf_global_ctrl
> >  - Add line to changelog for patch 3/8
> > 
> > v3 => v4:
> >  - Allow tests to set the guest func multiple times
> >  - Style fixes throughout kvm-unit-tests patches, per Krish's review
> > 
> > v4 => v5:
> >  - Rebased kernel and kvm-unit-tests patches
> >  - Reordered and reworked patches to now WARN on a failed
> >    kvm_set_msr()
> >  - Dropped patch to alow resetting guest in kvm-unit-tests, as the
> >    functionality is no longer needed.
> > 
> > This patchset exposes the "load IA32_PERF_GLOBAL_CTRL" to guests for nested
> > VM-entry and VM-exit. There already was some existing code that supported
> > the VM-exit ctrl, though it had an issue and was not exposed to the guest
> > anyway. These patches are based on the original set that Krish Sadhukhan
> > sent out earlier this year.
> > 
> > Oliver Upton (6):
> >   KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL VM-{Entry,Exit} control
> >   KVM: nVMX: Load GUEST_IA32_PERF_GLOBAL_CTRL MSR on VM-Entry
> >   KVM: nVMX: Use kvm_set_msr to load IA32_PERF_GLOBAL_CTRL on VM-Exit
> >   KVM: nVMX: Check HOST_IA32_PERF_GLOBAL_CTRL on VM-Entry
> >   KVM: nVMX: Check GUEST_IA32_PERF_GLOBAL_CTRL on VM-Entry
> >   KVM: VMX: Add helper to check reserved bits in IA32_PERF_GLOBAL_CTRL
> > 
> >  arch/x86/kvm/pmu.h           |  6 ++++++
> >  arch/x86/kvm/vmx/nested.c    | 51 +++++++++++++++++++++++++++++++++++++++++++++++++--
> >  arch/x86/kvm/vmx/nested.h    |  1 +
> >  arch/x86/kvm/vmx/pmu_intel.c |  5 ++++-
> > 
> 
> Queued, thanks.
> 
> But I had to squash this in patch 8:
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 3129385..b6233ae 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -7161,6 +7161,7 @@ static void test_perf_global_ctrl(u32 nr, const
> char *name, u32 ctrl_nr,
>  		report_prefix_pop();
>  	}
> 
> +	data->enabled = false;
>  	report_prefix_pop();
>  	vmcs_write(ctrl_nr, ctrl_saved);
>  	vmcs_write(nr, pgc_saved);
> 
> and I'm not sure about how this could have worked for you.
> 
> Paolo

Thanks for the fix. This was an oversight of mine as I had only run the
tests I introduced individually. I'll be more thorough in future
changes, apologies.

--
Best,
Oliver
