Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F0E41984F
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 17:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235259AbhI0P7e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 11:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235119AbhI0P7d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 11:59:33 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DBEEC061575
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 08:57:55 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id v127so934447wme.5
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 08:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JR35HuKzGthWvmv9CEqJPefKanPo+GUZ6dckwUpLigk=;
        b=gih3EnHFCTKeAfABxRU6h6OIaW3q6XxmnJ7BB2hoX0s9KrPfdg/GLhAyjl1bGNr/9E
         +7PDztufqi8UOCdexyXc2otuZIynneBVwdEz3bQFX2f2C1kmNsODnwN5y2rPtJ0/Wi+i
         TNIKY6HJjSeFhDvJUdUaY6F4eOq/DqKG8wWgg+p9ggcm4B+aFKpdJXxEPPXC7IIm0FDL
         UUXOFGU2nfYtOlJw+rTYRI2Wtq/XfOXl2fzP6ILhLQ+RdLKbahBjx3Mxn8PCB+EkBgc+
         QO3saRNehYAIwCEP8oZjJufcp7lttIx3YvfLCWv75QDRiLUAJeYg3/s8aWMN/Y0Vrj1a
         u+uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JR35HuKzGthWvmv9CEqJPefKanPo+GUZ6dckwUpLigk=;
        b=TXXL07kk+zULxoanM+4WD+ohdMcBS4F0gelXXp0V7psz0HnKSQVfqwroUtrEqfmr2p
         CiZsp3Xp/4uW25j7SoLVFI20Zw2hIC6zafNRop33qALkGV1Cy/UpjM3G8DW8UGGG8uxq
         uOLzLyRI/+aLDlCc6rUs7P/Oemf6FEHVIi6VuDdTJxz1wUFHUtXUU5z8uqfDSfu0gE3U
         9q1XydraFg5EyF/ZariYWAKzdRdOYkJE23lzSrD3oiY2f5vzrTczeyxFVqMbMJKgNPBO
         gfjz49tCrioravQUOMtRPLtWdj0FGUpPxE5kQX9esEo9TjUyD52tXCS0qDmVBapjrD7+
         Y0vg==
X-Gm-Message-State: AOAM531DFbYW2mGTODiZ5+Hh+jKofGd8sukNosjdvO33tauhP/a3mVSb
        JS/urWLg4ZJlkLJDwWeupYKfzw==
X-Google-Smtp-Source: ABdhPJyRdPlCVLYtYfKxxPD3CfGn+QmcYz7W2HksgyRTiXomX+tB+0JxkqXAM8syfEH3XlcesX3ELQ==
X-Received: by 2002:a1c:1d92:: with SMTP id d140mr8232533wmd.17.1632758273549;
        Mon, 27 Sep 2021 08:57:53 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:fa68:b369:184:c5a])
        by smtp.gmail.com with ESMTPSA id l18sm682277wrp.56.2021.09.27.08.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 08:57:53 -0700 (PDT)
Date:   Mon, 27 Sep 2021 16:57:50 +0100
From:   Quentin Perret <qperret@google.com>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, will@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com,
        christoffer.dall@arm.com, drjones@redhat.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: Re: [RFC PATCH v1 05/30] KVM: arm64: add accessors for
 kvm_cpu_context
Message-ID: <YVHp/sbRuCYyroz5@google.com>
References: <20210924125359.2587041-1-tabba@google.com>
 <20210924125359.2587041-6-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924125359.2587041-6-tabba@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Friday 24 Sep 2021 at 13:53:34 (+0100), Fuad Tabba wrote:
> +static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
> +{
> +	__ctxt_write_spsr(&vcpu_ctxt(vcpu), val);
> +}
> +
> +static void __vcpu_write_spsr_abt(struct kvm_vcpu *vcpu, u64 val)
> +{
> +	__ctxt_write_spsr_abt(&vcpu_ctxt(vcpu), val);
> +}
> +
> +static void __vcpu_write_spsr_und(struct kvm_vcpu *vcpu, u64 val)
> +{
> +	__ctxt_write_spsr_und(&vcpu_ctxt(vcpu), val);
>  }

I think you remove those at a later point in the series, do we really
need to add them here?

Cheers,
Quentin
