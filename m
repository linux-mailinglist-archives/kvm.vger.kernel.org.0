Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98792A188E
	for <lists+kvm@lfdr.de>; Sat, 31 Oct 2020 16:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgJaP1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Oct 2020 11:27:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30502 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728041AbgJaP1w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 31 Oct 2020 11:27:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604158071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CeMu0Q01glqXmwQt4+Bz8jKavcgfaMX1Jr1NHqeLsAQ=;
        b=NONAWzppjNLdwAyymQLF4tu6bAEMqKA8Fge4+9YYI2S+V0xNgbdI5hyKcqtKs92WYNrvt0
        duvM+62S8zwUZVFmNUQMlTaIYJbdx2sFnJfL8V62Ei11GmGWgGZ1vsWV2PF841CQuHcaem
        gvIkwdNMcsqT1ZU2JxiHb/xHVCdoFUM=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-tz91dP8XMaybj9-vY6WPtg-1; Sat, 31 Oct 2020 11:27:49 -0400
X-MC-Unique: tz91dP8XMaybj9-vY6WPtg-1
Received: by mail-qk1-f197.google.com with SMTP id e23so815495qkm.20
        for <kvm@vger.kernel.org>; Sat, 31 Oct 2020 08:27:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CeMu0Q01glqXmwQt4+Bz8jKavcgfaMX1Jr1NHqeLsAQ=;
        b=lnN1uaekVbHx7mGtqXwFzNnNWBFns6Spt1zAPE81F9Djswxsly/Azy9q+w2qCtCTTB
         /br5SgfE6J3aRA1UBQH+f61YSIXD4XvYqcfl++VB7Q+vFYN6xfVDU1jkW9RRmskWHEaJ
         B/MHaiLNJMkBNSUuTP3gQYA+Kv2hk/tHyQsDtHKcxOm1gBeuEc2yVFU5zzUc0Ca+4ggN
         IyeC1eFqCTTkQYkoVJqCSUpNp1e/6qL0oqTh7M2iXaRq+5Nz3ox746x4hzeUG4d8otFZ
         JTE/MgFvDJtWbYGGfJPLaOtbN/JwlsBjvzHIPzpESDJzo6W12TAc65d27OsOCAxACS0p
         Wxqw==
X-Gm-Message-State: AOAM530YJO5g9WN1mrLwgfOb6sMi/nCHr5Pv+XcSRBgIcZ3k7mfngHdp
        TW4/odIDpzl9YJ/Feh33ibjdDNHN8fGpFmBDJVV37SUgj5n2wyIGjkqA+DwyXF1TZBWbmdBWHZN
        pGacU9ArPR3f3
X-Received: by 2002:a37:5904:: with SMTP id n4mr7238276qkb.364.1604158068836;
        Sat, 31 Oct 2020 08:27:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDh0Hlgox2NxrXVtI9hV5MphLGsUtUUJ1oY7eXHwn7qxgz6UGiFk4EsUQC501eZpz9ZjrkKQ==
X-Received: by 2002:a37:5904:: with SMTP id n4mr7238259qkb.364.1604158068650;
        Sat, 31 Oct 2020 08:27:48 -0700 (PDT)
Received: from xz-x1 (toroon474qw-lp140-04-174-95-215-133.dsl.bell.ca. [174.95.215.133])
        by smtp.gmail.com with ESMTPSA id j50sm1851112qtc.5.2020.10.31.08.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 08:27:47 -0700 (PDT)
Date:   Sat, 31 Oct 2020 11:27:46 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Steffen Dirkwinkel <kernel-bugs@steffen.cc>
Subject: Re: [PATCH 2/2] KVM: X86: Fix null pointer reference for KVM_GET_MSRS
Message-ID: <20201031152746.GE6357@xz-x1>
References: <20201025185334.389061-1-peterx@redhat.com>
 <20201025185334.389061-3-peterx@redhat.com>
 <c20d7c85-b2f3-608a-833f-093363fac5f5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c20d7c85-b2f3-608a-833f-093363fac5f5@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 31, 2020 at 03:06:59PM +0100, Paolo Bonzini wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index ce856e0ece84..5993fbd6d2c5 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -259,8 +259,8 @@ static int kvm_msr_ignored_check(struct kvm_vcpu *vcpu, u32 msr,
> >  
> >  	if (ignore_msrs) {
> >  		if (report_ignored_msrs)
> > -			vcpu_unimpl(vcpu, "ignored %s: 0x%x data 0x%llx\n",
> > -				    op, msr, data);
> > +			kvm_pr_unimpl("ignored %s: 0x%x data 0x%llx\n",
> > +				      op, msr, data);
> >  		/* Mask the error */
> >  		return 0;
> >  	} else {
> > 
> 
> I committed Takashi Iwai's very similar patch.  Please resend 1/2 with
> reviewer comments addressed, thanks!

Sorry for a late reply (to reviewers).

Oh, how did I miss the other vcpu reference... that one is definitely better. :)

Will respin shortly on the test.

Thanks,

-- 
Peter Xu

