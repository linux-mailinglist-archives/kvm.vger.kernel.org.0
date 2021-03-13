Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39F6339FC0
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 19:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234321AbhCMSHO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Mar 2021 13:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbhCMSGp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Mar 2021 13:06:45 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A31C061574;
        Sat, 13 Mar 2021 10:06:45 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id l13so6393122qtu.9;
        Sat, 13 Mar 2021 10:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qmztczQ8nwlB2ZsLfNT+eUr55Vm8FQvEeckkwobT4Fo=;
        b=J7BNxH+9zAJSpZT49oEVvoljADKL0mcaBvvxC0C2vlCBSuitKhdzpCMx3KI7BfdLdR
         /OVlpcir79WWkWYHgudf7wc9wI4ikkGV/oj89W25FwqepTpfgBDOv3TxCNN1z0uOgJoF
         SY+FzlHUH+gZypRWujGQZPCo07NOekPMlT6BO8sJqBPNB+gWKZZKCGZuL/ixT0afD7hq
         OlHTJCfLA8dLtgYqCXf/rFP71y5lTue4Qkq7ePDIAbamQLwhl562yOeZmScANXRCkB69
         aY1f6sROr7S36dtchcv8kUNsxshmcp7+lC20LpV2jCcBoL7a980V+Pouv5fVkFtI4Qzb
         bDKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=qmztczQ8nwlB2ZsLfNT+eUr55Vm8FQvEeckkwobT4Fo=;
        b=j2xSpHUseQZns+GrsvZe0cZ1wXLmFVJJij0sMkONS0QzpFzZiYtOqMtoZFMQyG/N0+
         iyeHsxdhwBpm1yn44Lvdmc6yzoLZyUvTbC9B21nay6DUcmetErQNwhe2ZwSfK9s/N6AA
         Q0+gxa4Ask3XXdpPgESa1l1vYhxz5sYKPbYsVZ5/60Q9cSmz5jKxjXffIHmav6HlRUZw
         iJvD8tn22wyUVjCa+4g0vziee72EQXqxuo2Q9ctbiTHcSM7kYQegoT+pJjuGnV3l/erh
         TNiV5TW/O3PriavS0jfZvkHPhfRIhEUlzZl4r/bkjQ12nTrp46i8R2C6itlo+Lo/HbOS
         ohJQ==
X-Gm-Message-State: AOAM531n1pSpQ+MwwtfqHwaweY1o137huGAWIvHZtNA71ZLbw6h0OvjL
        KBOSJqseyC5HtZ89UKdn+GI=
X-Google-Smtp-Source: ABdhPJx3TZWYKiCGPWxCw/QJBwue9nIX+6EKNJ5BoCzcywtVpMNr5EN/6N8MBRGBMGQWeo413t9GRQ==
X-Received: by 2002:ac8:4543:: with SMTP id z3mr17030003qtn.286.1615658803977;
        Sat, 13 Mar 2021 10:06:43 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:fde1])
        by smtp.gmail.com with ESMTPSA id k138sm7201936qke.60.2021.03.13.10.06.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 10:06:43 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Sat, 13 Mar 2021 13:05:36 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Jacob Pan <jacob.jun.pan@intel.com>
Cc:     Vipin Sharma <vipinsh@google.com>, mkoutny@suse.com,
        rdunlap@infradead.org, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com,
        pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>
Subject: Re: [RFC v2 2/2] cgroup: sev: Miscellaneous cgroup documentation.
Message-ID: <YEz+8HbfkbGgG5Tm@mtj.duckdns.org>
References: <20210302081705.1990283-1-vipinsh@google.com>
 <20210302081705.1990283-3-vipinsh@google.com>
 <20210303185513.27e18fce@jacob-builder>
 <YEB8i6Chq4K/GGF6@google.com>
 <YECfhCJtHUL9cB2L@slm.duckdns.org>
 <20210312125821.22d9bfca@jacob-builder>
 <YEvZ4muXqiSScQ8i@google.com>
 <20210312145904.4071a9d6@jacob-builder>
 <YEyR9181Qgzt+Ps9@mtj.duckdns.org>
 <20210313085701.1fd16a39@jacob-builder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210313085701.1fd16a39@jacob-builder>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Sat, Mar 13, 2021 at 08:57:01AM -0800, Jacob Pan wrote:
> Isn't PIDs controller doing the charge/uncharge? I was under the impression
> that each resource can be independently charged/uncharged, why it affects
> other resources? Sorry for the basic question.

Yeah, PID is an exception as we needed the initial migration to seed new
cgroups and it gets really confusing with other ways to observe the
processes - e.g. if you follow the original way of creating a cgroup,
forking and then moving the seed process into the target cgroup, if we don't
migrate the pid charge together, the numbers wouldn't agree and the seeder
cgroup may end up running out of pids if there are any restrictions.

> I also didn't quite get the limitation on cgroup v2 migration, this is much
> simpler than memcg. Could you give me some pointers?

Migration itself doesn't have restrictions but all resources are distributed
on the same hierarchy, so the controllers are supposed to follow the same
conventions that can be implemented by all controllers.

> BTW, since the IOASIDs are used to tag DMA and bound with guest process(mm)
> for shared virtual addressing. fork() cannot be supported, so I guess clone
> is not a solution here.

Can you please elaborate what wouldn't work? The new spawning into a new
cgroup w/ clone doesn't really change the usage model. It's just a neater
way to seed a new cgroup. If you're saying that the overall usage model
doesn't fit the needs of IOASIDs, it likely shouldn't be a cgroup
controller.

Thanks.

-- 
tejun
