Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1FE5F7DDB
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 21:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiJGTU6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 15:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbiJGTUa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 15:20:30 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D04186F81
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 12:20:12 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 70so5167771pjo.4
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 12:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HXZ1GfKuHT9UGVo4SAOoHI33UPFVGT7JQy34k6Icygc=;
        b=IfKi7mt3k9vZqtNfOFpZzrfbB8pVuZVTBL2DyxZQucV2Dq+aWcSJobIgh9gwSsFqqp
         3NrP1+gpBo8d5F+syz7vxk4m4StRuMaacllHBXyzFK0eIGaDRGpSWz2ST0dSMOsNjgQv
         FcDre+eUDJl5DL8S5mvMhECY76lz4aJavMNChbbhL+oMkmVqX9RcvVzAyRYDnwVAm2Mr
         cFwxO716m+yFwddzaEl10+9qZ5TPBALfPVCn4msulW4mIiETZjnnBu9paxgRe8GiiGSE
         y+SkQO3jytm2RRoDevWEnO6aI2Sbsx6atwP37O7A7nJ3D5s31dEllASpvPbXeCkVbRFY
         s7IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HXZ1GfKuHT9UGVo4SAOoHI33UPFVGT7JQy34k6Icygc=;
        b=sQFs6PHXjtgV42fXUPDJK92NFQwdK1QSucKVVSzEmyzSQOgHQwZpaT3N65zd26OBc+
         WRcTMz3aaHqVUoTEAXtsDiW7qgOG3hoJqyXxXREell8jxTqjUZsRcUZJZFwcAlRIGB7p
         LzycofZXy7s+RCaEHnFkIK4NKLu+6o75APsMe9pufwaKhyPgkBzMTihJBu8A8nvjq1jI
         NyhtuGnZdZo9DNnTaJaxj17u7NQ+5yQzmTmUdVb3GzyIRcwEPzj2zXEjIfrx+nlB6JDP
         prKgtNiFF9nVS10gSwyQNixb49pGCraR1T9Dt0e1opcnjwUnsfkH96GVRzJV0YicB0sm
         TorQ==
X-Gm-Message-State: ACrzQf3ukKNQJQAxmnITz+LQ8xRiyPWbvUiaGeov34x5/BNTayIAWD5S
        YycXpwpfI7U22FzsGIvhxtomzg==
X-Google-Smtp-Source: AMsMyM7bqhZdqYvdcJpoIeMZCd67ay+OjHpj7Ze1PfuhEo+aFDqcVS+OYI0LndH/MBdsGm8/85A66g==
X-Received: by 2002:a17:902:ce09:b0:178:bb78:49a5 with SMTP id k9-20020a170902ce0900b00178bb7849a5mr6246047plg.100.1665170412253;
        Fri, 07 Oct 2022 12:20:12 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id gm7-20020a17090b100700b0020669c8bd87sm1857346pjb.36.2022.10.07.12.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 12:20:11 -0700 (PDT)
Date:   Fri, 7 Oct 2022 19:20:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, james.morse@arm.com,
        borntraeger@linux.ibm.com, david@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v6 1/5] KVM: Implement dirty quota-based throttling of
 vcpus
Message-ID: <Y0B753GVEgGP/Iqg@google.com>
References: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
 <20220915101049.187325-2-shivam.kumar1@nutanix.com>
 <Y0B5RFI25TotwWHT@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0B5RFI25TotwWHT@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 07, 2022, Sean Christopherson wrote:
> On Thu, Sep 15, 2022, Shivam Kumar wrote:
> Let's keep kvm_vcpu_check_dirty_quota(), IMO that's still the least awful name.
> 
> [*] https://lore.kernel.org/all/Yo+82LjHSOdyxKzT@google.com

Actually, I take that back.  The code snippet itself is also flawed.  If userspace
increases the quota (or disables it entirely) between KVM snapshotting the quota
and making the request, then there's no need for KVM to exit to userspace.

So I think this can be:

static void kvm_vcpu_is_dirty_quota_exchausted(struct kvm_vcpu *vcpu)
{
#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
	u64 dirty_quota = READ_ONCE(vcpu->run->dirty_quota);

	return dirty_quota && (vcpu->stat.generic.pages_dirtied >= dirty_quota);
#else
	return false;
#endif
}

and the usage becomes:

		if (kvm_vcpu_is_dirty_quota_exhausted(vcpu))
			kvm_make_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu);

More thoughts in the x86 patch.
