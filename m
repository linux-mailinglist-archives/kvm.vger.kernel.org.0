Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A80A571399
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 09:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbiGLHz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 03:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232519AbiGLHzY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 03:55:24 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95BC9D502;
        Tue, 12 Jul 2022 00:55:23 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id a15so6800500pfv.13;
        Tue, 12 Jul 2022 00:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jB0/sBewzpAG176RgBmVCEhPfPoNVC+csgcU/c7Q6og=;
        b=IRoSMJWbprULskG7mdeaOOmkltqpld0mdJe52BBdf4hD/lxcPWweBCqOpxoRSj3Ye1
         QEkZXSnZLxNnwjWz1F1scbwAMHncxgphl3kngkzvsNIoYOz43RAEfRnB1ajveSdLYi9Y
         n0Eft1Nm3zNWZyYSqieS/NqwmgWvuPmpd1fMnNEXeBj6yQKxz1ksKZdOZ7hWHF2f+c5X
         PrQ2VP/MfufZzl0bThMhX0HuRLgYMGgYASqSPG0g3hDbDzLg/7sLV4KhOagh7JcqmsNR
         sZOtrnTID3W/cL07uzXsUtQ1zwjlTOcs3a6+/Fo/juf7CMA2QdNnUQB1a81FIgI7F4EJ
         VcIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jB0/sBewzpAG176RgBmVCEhPfPoNVC+csgcU/c7Q6og=;
        b=QTva4428mzBOx6gSyZbO3MMkrZK9IcyXevGlrLotfQ8vnjz9m7u22d0boskHT64EQx
         2TS+PIbDwa7Uycn3IC3ABnKiABykSNjJLDxHyg8x8LLkMxUeqQg4ij3wMQO+Su4eh6+P
         /veYQpUwNSZq/kvHkRztXj+8kbyVPrC2+4ZIuMgZqMwyzwPkloCEUiUClfMqCNX/Joa/
         bUCCuxyymce4ZuWatHcs2GyF74yGqUanE2IqyvtjqGZojB6jZNlueFP1G/Ytvcl0/boF
         6HdWcZyRZpsxVtNYp5VJmluE8oHR5X0j1jn8ozRtVBw+DAdr5UeiVb8TVrQlMhtzQ0lH
         NTqQ==
X-Gm-Message-State: AJIora9StDcfj1minMyEmW73D6SnsssHMleWCtdvXZQUrAd1hphkV5AK
        idAYjuM6T/mfzqrPcvVf5hE=
X-Google-Smtp-Source: AGRyM1uRJjALwfLCu9+aM4GVOdCC5GDtgrbVABOzNKHa+qPSzzLz0XhgMVRBRkQKUCGnPbRqadoZcA==
X-Received: by 2002:a05:6a00:2410:b0:528:be6e:8c2e with SMTP id z16-20020a056a00241000b00528be6e8c2emr22496038pfh.31.1657612523274;
        Tue, 12 Jul 2022 00:55:23 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id q5-20020a170902a3c500b00163f8eb7eb3sm6069166plb.196.2022.07.12.00.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 00:55:22 -0700 (PDT)
Date:   Tue, 12 Jul 2022 00:55:21 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 029/102] KVM: TDX: allocate/free TDX vcpu structure
Message-ID: <20220712075521.GI1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <dad0333516bcdb0fdeccc9d1483299aeae8d80fd.1656366338.git.isaku.yamahata@intel.com>
 <2ecd255ac85fac7ffa1b90975c9e08f11ddee149.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2ecd255ac85fac7ffa1b90975c9e08f11ddee149.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 28, 2022 at 11:34:55PM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > The next step of TDX guest creation is to create vcpu.  Allocate TDX vcpu
> > structures, initialize it.  Allocate pages of TDX vcpu for the TDX module.
> > 
> > In the case of the conventional case, cpuid is empty at the initialization.
> > and cpuid is configured after the vcpu initialization.  Because TDX
> > supports only X2APIC mode, cpuid is forcibly initialized to support X2APIC
> > on the vcpu initialization.
> 
> The patch title and commit message of this patch are identical to the previous
> patch.
> 
> What happened? Did you forget to squash two patches together?

Forgot to squash this patch into the previous patch. Will fix it.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
