Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8A66A4D23
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 22:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjB0V0M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 16:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjB0V0J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 16:26:09 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA422054D;
        Mon, 27 Feb 2023 13:26:08 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id h11-20020a17090a2ecb00b00237c740335cso6487878pjs.3;
        Mon, 27 Feb 2023 13:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iRgWuAbWaYxaiebMMWCeq+aeo/6fiHCnGOaa9qpqar0=;
        b=FLR3Uzb2mMn6x7N41MVMKirl5eDlUeQFmHrQzq4KuYUoJj+7s7Cn2vZ9vtgN2irNo4
         6mQ+vt/ENjeuoAhG/aICwWXdpPgtN9rG1fgBuXdjRKe0Z9diRDVB9BDSshEIn5bSW2D+
         uDZa3D5JkvyN9LxNMElUiDhV+qysCG6ozueK1vk3tSo9rTLk3EC0wLjgTEIG262gN83s
         ZLjbaCfJYE4bVoFBtsEWAsVEvRLVWYDmDRl9VCbX5syj1oT20kHYxEl6lQ44OR+x9kpM
         1/Ne/DH9EDbOmqOMGX5nukYcATlIikNtu48eO3sCGXxo8KzU6B7W8fm1RyYvM6+Cznx6
         SBxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iRgWuAbWaYxaiebMMWCeq+aeo/6fiHCnGOaa9qpqar0=;
        b=INjl3zYZWATofMjtQn4zL3ftCCOjIYYZadPc3YQQKqckbmD//AiJW5Ws9vv+4IwRbG
         1capKuq6p33hhUO8ZemFTuSuYkx6GmfH79mwvwiPlp2G/NLDe5AamU3MQWHEM6TpR/rn
         AXWXY/3hvmLlC0HxPWqj+gpYnqZt9YrFtsZWmpw9Sgp4oz5+yt1P07pWDHgzGO2/bbV8
         gE/RKNzzQ29EatozQ8/jSL1hb5CWrCFtJMvfQPRGwaVM2vhKy3Kc7OlahcCusk/i7Ifa
         M80TZCHeCblZj7fBIzIqZDFEcHCdUBRIePVN8CqHT0pSCKqZ7Bl3vMLGIIWRzWgxMXuy
         knxg==
X-Gm-Message-State: AO0yUKVS4tWcrvjvPzXcPqiONQ7QkWi2YAsxeCEIsIw4x4oq1dsMd1dh
        GfXupudIuPfDvYNRUE7m+9Y=
X-Google-Smtp-Source: AK7set/lb4Hog6/fs4T3YpHJSQaUlbZos02J/Ar96DtxxxfFWW1TluOahg0CUwmMwUCetiwE+Oz23w==
X-Received: by 2002:a17:903:32d2:b0:19a:9686:ea8b with SMTP id i18-20020a17090332d200b0019a9686ea8bmr384992plr.28.1677533167726;
        Mon, 27 Feb 2023 13:26:07 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id ik6-20020a170902ab0600b0019cb4166266sm5054462plb.83.2023.02.27.13.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 13:26:07 -0800 (PST)
Date:   Mon, 27 Feb 2023 13:26:05 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v11 017/113] KVM: Support KVM_CAP_MAX_VCPUS for
 KVM_ENABLE_CAP
Message-ID: <20230227212605.GF4175971@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <01e061779b88ce4d32bbe483ed2bd3224cd8e330.1673539699.git.isaku.yamahata@intel.com>
 <5f9870acec07c47de5bab460c8c0d4a2c0db08fc.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5f9870acec07c47de5bab460c8c0d4a2c0db08fc.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 16, 2023 at 04:44:21AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Thu, 2023-01-12 at 08:31 -0800, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > TDX attestation includes the maximum number of vcpu that the guest can
> > accommodate.  
> > 
> 
> I don't understand why "attestation" is the reason here.  Let's say TDX is used
> w/o attestation, I don't think this patch can be discarded?
>
> IMHO the true reason is TDX has it's own control of maximum number of vcpus,
> i.e. asking you to specify the value when creating the TD.  Therefore, the
> constant KVM_MAX_VCPUS doesn't work for TDX guest anymore.

Without TDX attestation, this can be discarded.  The TD is created with
max_vcpus=KVM_MAX_VCPUS by default.


> 
>  
> > For that, the maximum number of vcpu needs to be specified
> > instead of constant, KVM_MAX_VCPUS.  Make KVM_ENABLE_CAP support
> > KVM_CAP_MAX_VCPUS.
> > 
> > Suggested-by: Sagi Shahar <sagis@google.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  virt/kvm/kvm_main.c | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index a235b628b32f..1cfa7da92ad0 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -4945,7 +4945,27 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
> >  		}
> >  
> >  		mutex_unlock(&kvm->slots_lock);
> > +		return r;
> > +	}
> > +	case KVM_CAP_MAX_VCPUS: {
> > +		int r;
> >  
> > +		if (cap->flags || cap->args[0] == 0)
> > +			return -EINVAL;
> > +		if (cap->args[0] >  kvm_vm_ioctl_check_extension(kvm, KVM_CAP_MAX_VCPUS))
> > +			return -E2BIG;
> > +
> > +		mutex_lock(&kvm->lock);
> > +		/* Only decreasing is allowed. */
> 
> Why?

I'll make it x86 specific and will drop this check.


> > +		if (cap->args[0] > kvm->max_vcpus)
> > +			r = -E2BIG;
> > +		else if (kvm->created_vcpus)
> > +			r = -EBUSY;
> > +		else {
> > +			kvm->max_vcpus = cap->args[0];
> > +			r = 0;
> > +		}
> > +		mutex_unlock(&kvm->lock);
> >  		return r;
> >  	}
> >  	default:
> 
> Also, IIUC this change is made to the generic kvm_main.c, which means other
> archs are  affected too.  Is this OK to other archs?  Why such change cannot
> TDX-specific (or, at least x86, or vmx specific)? 

Ok, I made it x86 specific. 
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
