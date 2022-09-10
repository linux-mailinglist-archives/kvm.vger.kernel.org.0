Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4F05B47E1
	for <lists+kvm@lfdr.de>; Sat, 10 Sep 2022 20:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiIJSLr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Sep 2022 14:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiIJSLq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Sep 2022 14:11:46 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760A04B0D4;
        Sat, 10 Sep 2022 11:11:45 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id fs14so4318126pjb.5;
        Sat, 10 Sep 2022 11:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=pAWZMQ4OebAxACXO2jGPq2qtXaPGJKbsWZHu2snLesU=;
        b=FSy5hLs/8uHSnX2eCqR/NPTOot9ONoHZuJBzGA+4ya5og1h23dEPAvZJpqsd0HzFVw
         s05EJvefDSk4Y+lxe2qG5foA+80l4gEDw5FonWsYSzhF32TNLtCoiouych0K3VdALK+8
         ikwTHJmcqmNY0vPhXNUhkhs+QdB7705DRzciphKZvzH18vqmcTdOxoui0o0EWb5ArYS/
         YLV+C4eE/zH5Ux4vXJoBWfTR/s7MR3MFgUpAIPjAoftrlcHkvwOrnv3wfTUYaJcu3exQ
         Lb2x0QxZUiOOB70dwBHlkuHejpf26QQ7e0kCfdDxfIcfpuUDLN7kQjTS4ee9FjUZSPmM
         udWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=pAWZMQ4OebAxACXO2jGPq2qtXaPGJKbsWZHu2snLesU=;
        b=e/Kddm22lRSRENjC7l2OBqMlRzgyrB2Je34rBofjHMFFgwPyU93UISPgYy+AUvwCeH
         tqbK4V5ahFFFSMGRWreY9SBXwiggy88aC+aVbKCJysh+8zJaAF2nPnlAU3098EiWWSGr
         Rcf7Qam+Sn48IPSpgm+gmjNpEaP/0R6m4RBj94BWtMa5at3MJFQim66UvpZPiJm/bzog
         67GSObKz5UHkLFLk2FNNjleVvDijVY7XOFjBfNcQRPwsVEJjEcLOyZqsoxSFeoVWFXTO
         MVvKjsoPJlAcVHlXViR59w0p98FZfSjdbW13Y6bb0YJqarxqcOLKPrayy+K3u8oPJx1x
         XHvA==
X-Gm-Message-State: ACgBeo1LHxB9qDMq4WlbHFnFJZjW5iIwANOmCq9V7cjAf+7YNlHUQRuT
        Dbhy/BfrXru4MjreZHlwBkQ=
X-Google-Smtp-Source: AA6agR6ZOHuxwi86aeOxm1Mk6kKDWGMGK8Maowlh/sa/0K73mfbj9bqRcwDM3xCcy6k+F4zK5f85Yg==
X-Received: by 2002:a17:90b:4ac3:b0:1fd:ded0:ea80 with SMTP id mh3-20020a17090b4ac300b001fdded0ea80mr15410157pjb.142.1662833504838;
        Sat, 10 Sep 2022 11:11:44 -0700 (PDT)
Received: from localhost ([192.55.55.56])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902e5c400b00172fad607b3sm2565372plf.207.2022.09.10.11.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Sep 2022 11:11:44 -0700 (PDT)
Date:   Sat, 10 Sep 2022 11:11:43 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     isaku.yamahata@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Yuan Yao <yuan.yao@linux.intel.com>, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>
Subject: Re: [PATCH v4 10/26] KVM: Drop kvm_count_lock and instead protect
 kvm_usage_count with kvm_lock
Message-ID: <20220910181143.GC699006@ls.amr.corp.intel.com>
References: <cover.1662679124.git.isaku.yamahata@intel.com>
 <c95e36034d7ffd67b7afed3ba790de921426e737.1662679124.git.isaku.yamahata@intel.com>
 <YxqtfmhBGQlkhTvU@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YxqtfmhBGQlkhTvU@gao-cwp>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 09, 2022 at 11:05:34AM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> >+	 * cpu_hotplug_disable() and other CPUs are offlined.  No need for
> >+	 * locking.
> >+	 */
> >+	lockdep_assert_not_held(&kvm_lock);
> >+
> >+	if (kvm_usage_count) {
> >+		preempt_disable();
> > 		hardware_disable_nolock(NULL);
> >+		preempt_enable();
> 
> kvm_suspend() is called with interrupt disabled. So, no need to disable
> preemption.
> 
> /**
>  * syscore_suspend - Execute all the registered system core suspend callbacks.
>  *
>  * This function is executed with one CPU on-line and disabled interrupts.
>  */
> int syscore_suspend(void)

Thanks, I'll fix it with a comment.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
