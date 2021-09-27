Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6402D41995A
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 18:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235701AbhI0QmB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 12:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235749AbhI0Qlu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 12:41:50 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2516C061604
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 09:40:07 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id t8so53119421wrq.4
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 09:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uBxEi6AYAf/IDfN1v8J251RrBh4CFzk1e5mArk5PNvU=;
        b=ShmHcW7/EwN9y31VztAl5sWbgy+qbrOKhzAJBDeQTwUbLr3EqJa1zCP54fk27oJaHN
         nX+uDlhxuiJm3MuzUgDfp71rKNZvZ/NtJgJoIXrNrdO1oET1vtkPUCJFKKuxcfL8Kd9r
         9pXlnfVc5BbCh9f1BDvaKpeLDgurgmakIcGdrEJt87/+j7UM2g/CJGgDD7aJQz60TKkw
         D2LnDAOLUSm1coZM2D8JKP+EklxtaxFNBRJkjvZzmhDBc8X374FhqrUFYc/mz4WbES3t
         YNN1I+kET1+Jp/qfcCwCE5u8Mu+wX/3NCdC6+iqAiUdPwtk043eGTxBDETr8YPgo4a85
         +beg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uBxEi6AYAf/IDfN1v8J251RrBh4CFzk1e5mArk5PNvU=;
        b=c6qjJHHKBOaOVWUOxLw+EuUzJhINGt1FlFUPLMPo5CCE31iRK7o888RmM8yhjwxsOU
         Hid19bN+JAHweyEcE8ZBw7g/YWZmQS5NFN1MZ3SIgToxKor1con+OUOqHz7lHqpotuuC
         grYmA6lfD6T4ZxVH9AhNaHzt6Tvf690/dF8AsPbeHPLVXtLptb+6pUu6Irneyr21bB8m
         yrAmAxfKUlPkT6YLqXQ4l/WwpEsKT9BIAO2sCjFoyqyhShI1wjA6FYFaVTk7fOMJ55Hr
         OoOJHLIu0Ps2O4WeJO7QTi1mKcxA9cuCv8PBkdtHQdqOsw4KPBCU7QQKHo3q5rkt7zWz
         Ay9A==
X-Gm-Message-State: AOAM5334SiQw7vauTTibUB/iEP7XKofVLMgB3ebuzGsne8299qNsW2HL
        cpim6Lm4XkOIohv+F+k1+emhGw==
X-Google-Smtp-Source: ABdhPJxeIsgFjgYqOUquyC+YdPRjFg7ImEHfUd+nnFiThBHOZhs4dFClXfQIVL5NXC3K9mRijFdtDA==
X-Received: by 2002:adf:f48b:: with SMTP id l11mr977771wro.254.1632760806108;
        Mon, 27 Sep 2021 09:40:06 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:fa68:b369:184:c5a])
        by smtp.gmail.com with ESMTPSA id x4sm18967wmi.22.2021.09.27.09.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 09:40:05 -0700 (PDT)
Date:   Mon, 27 Sep 2021 17:40:03 +0100
From:   Quentin Perret <qperret@google.com>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, will@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com,
        christoffer.dall@arm.com, drjones@redhat.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: Re: [RFC PATCH v1 12/30] KVM: arm64: COCCI: add_hypstate.cocci
 use_hypstate.cocci: Reduce scope of functions to hyp_state
Message-ID: <YVHz48IuvHsHRaiG@google.com>
References: <20210924125359.2587041-1-tabba@google.com>
 <20210924125359.2587041-13-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924125359.2587041-13-tabba@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Friday 24 Sep 2021 at 13:53:41 (+0100), Fuad Tabba wrote:
> Many functions don't need access to the vcpu structure, but only
> the hyp_state. Reduce their scope.
> 
> This applies the semantic patches with the following commands:
> FILES="$(find arch/arm64/kvm/hyp -name "*.[ch]" ! -name "debug-sr*") arch/arm64/include/asm/kvm_hyp.h"
> spatch --sp-file cocci_refactor/add_hypstate.cocci $FILES --in-place
> spatch --sp-file cocci_refactor/use_hypstate.cocci $FILES --in-place
> 
> This patch adds variables that may be unused. These will be
> removed at the end of this patch series.

I'm guessing you decided to separate things out to make sure this patch
is purely the result of a coccinelle run w/o manual changes?

It looks like the patch to remove the unused variables is a 'COCCI'
patch too, so maybe it would make sense to run it here directly after
the first coccinelle run, and squash the result into this patch? The
resulting patch would still be entirely auto-generated, and wouldn't
have these somewhat odd unused variables. Thoughts?

Thanks,
Quentin
