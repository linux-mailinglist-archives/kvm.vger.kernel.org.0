Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11265A97B6
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 02:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbfIEAtZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 20:49:25 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43408 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbfIEAtY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 20:49:24 -0400
Received: by mail-pg1-f195.google.com with SMTP id u72so366296pgb.10
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2019 17:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=amRAgWbAOx5JoHHToWG8P7fKQ6oQS72rmXfp0fZegME=;
        b=XEjooYbQil1oaGB5yF/rvRi9k4zLXNHPnEBEdy3Bda6HSq+wEBbWSb80I+U0V44lBA
         kHPm28vBXSPKk7Kw1axDylnhesyT2nv0qZmdg17horXHsJbVNxV3PR9Gliseo0yxgaB/
         Qdbh3mN+vmq4N15iO+EjQjnz4U+d2zKYHnmYZaQYCi4I6VtyrBSRjCibHNWuqwcU1g0v
         4Hf3AlNwSq4Ll2g3gFeApN83TmjEX2izirggyErE/WldQCgLjwTao2Mw0rgkZ7epg7ZZ
         w2o02SUl6PMIXGbdWR+S1eWA+7saRmhe/y67eKxL6v3W/Gta7hw4QXTHkNAAySO+Evu3
         Up6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=amRAgWbAOx5JoHHToWG8P7fKQ6oQS72rmXfp0fZegME=;
        b=tfj5aLkxpalWg1P05v5KW0PoDxZDhaYDUg0a4ra9KJfVyM9wv+VBoN/NiLHi0lWENz
         +BlgSpfI4535U2CM3dlK4B73JTPAzMRgl1yBrgu0sYJ/9HrGVDI+22zZs9pRD9B127mo
         qhKd804+ZGXruUzEeI4c9r08imGRqy2pI4PwcolpqFSIi09d3o9SdPzd6Tr6j1LALTPZ
         mZ3biLMoqMmGGdcvzf7SlYpwdavEB/2VTEjRmd69nNU8pj/N9rJJjbfs2cdCVZMpbJmD
         J0fAR5Ly2ADoMiacx50s+Yi6fytrqtLbZ//72ox/MY4ezC3cAUMyebINQtlW079DvoVG
         t6Kg==
X-Gm-Message-State: APjAAAUhtjeiloCLq10PNEKE9ZtWaBL/kOXitw2H+2lKW4BjhOVxKbXT
        bTZDUUxp9TXJfytRV/+tUHSmBQ==
X-Google-Smtp-Source: APXvYqw5BmoR9pX/MPFa9v00Ai3b/m7v8hMNsRlPzr0qGvi3XKpRmukds1tRZFnUSrLDK8Sd7g+0zQ==
X-Received: by 2002:a62:1810:: with SMTP id 16mr536689pfy.171.1567644563650;
        Wed, 04 Sep 2019 17:49:23 -0700 (PDT)
Received: from google.com ([2620:0:1009:11:73e5:72bd:51c7:44f6])
        by smtp.gmail.com with ESMTPSA id x5sm267233pfi.165.2019.09.04.17.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 17:49:23 -0700 (PDT)
Date:   Wed, 4 Sep 2019 17:49:19 -0700
From:   Oliver Upton <oupton@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [kvm-unit-tests PATCH v3 7/8] x86: VMX: Make
 guest_state_test_main() check state from nested VM
Message-ID: <20190905004919.GB107023@google.com>
References: <20190903215801.183193-1-oupton@google.com>
 <20190903215801.183193-8-oupton@google.com>
 <1fb19467-a743-1886-de52-a63bd19b0b00@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1fb19467-a743-1886-de52-a63bd19b0b00@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 04, 2019 at 05:25:40PM -0700, Krish Sadhukhan wrote:
> 
> 
> On 09/03/2019 02:58 PM, Oliver Upton wrote:
> > The current tests for guest state do not yet check the validity of
> > loaded state from within the nested VM. Introduce the
> > load_state_test_data struct to share data with the nested VM.
> > 
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >   x86/vmx_tests.c | 23 ++++++++++++++++++++---
> >   1 file changed, 20 insertions(+), 3 deletions(-)
> > 
> > diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> > index f035f24a771a..b72a27583793 100644
> > --- a/x86/vmx_tests.c
> > +++ b/x86/vmx_tests.c
> > @@ -5017,13 +5017,28 @@ static void test_entry_msr_load(void)
> >   	test_vmx_valid_controls(false);
> >   }
> > +static struct load_state_test_data {
> > +	u32 msr;
> > +	u64 exp;
> > +	bool enabled;
> > +} load_state_test_data;
> 
> A better name is probably 'loaded_state_test_data'  as you are checking the
> validity of the loaded MSR in the guest.

Other usages of structs for data sharing follow the previous naming
convention, but I slightly missed the mark with that as well. Other
structs seem to use the same prefix that the associated tests have (e.g.
ept_access_test_data corresponds to ept_access_test_*). To best match
that pattern, I should instead name it "vmx_state_area_test_data" (since
its used for both guest/host test data anyway.

That isn't to say there is a better pattern we could follow for naming
this! Which do you think is better?

> > +
> >   static void guest_state_test_main(void)
> >   {
> > +	u64 obs;
> > +	struct load_state_test_data *data = &load_state_test_data;
> > +
> >   	while (1) {
> > -		if (vmx_get_test_stage() != 2)
> > -			vmcall();
> > -		else
> > +		if (vmx_get_test_stage() == 2)
> >   			break;
> > +
> > +		if (data->enabled) {
> > +			obs = rdmsr(obs);
> 
> Although you fixed it in the next patch, why not use  'data->msr' in place
> of 'obs' as the parameter to rdmsr() in this patch only ?

Ugh, I mucked this up when reworking before sending out. 'data->msr'
should have appeared in this patch. I'll fix this.

> > +			report("Guest state is 0x%lx (expected 0x%lx)",
> > +			       data->exp == obs, obs, data->exp);
> > +		}
> > +
> > +		vmcall();
> >   	}
> >   	asm volatile("fnop");
> > @@ -6854,7 +6869,9 @@ static void test_pat(u32 field, const char * field_name, u32 ctrl_field,
> >   	u64 i, val;
> >   	u32 j;
> >   	int error;
> > +	struct load_state_test_data *data = &load_state_test_data;
> > +	data->enabled = false;
> >   	vmcs_clear_bits(ctrl_field, ctrl_bit);
> >   	if (field == GUEST_PAT) {
> >   		vmx_set_test_stage(1);
>

Thanks for the review, Krish. Looks like a typo I didn't rework into
this patch correctly, please let me know what you think on the other
comment.

--
Thanks,
Oliver
