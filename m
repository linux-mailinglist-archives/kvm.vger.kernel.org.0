Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0215E5543
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 23:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbiIUVj1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 17:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiIUVjZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 17:39:25 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03347A61E7
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 14:39:25 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id jm5so5969679plb.13
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 14:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=F49n0GDWtFmpiEIHBxknxSVaGxbsGKILhJWwZ2t+BIY=;
        b=mzGpGMY16PyeLUqED5yAMlsEOv41nLTQbC2DGal+lSNtg3tgwepvtu6yZsVNbpKNIX
         mK2p8FC6zZ5wE+oCfqn4hWEbLAB1G2VmzL8RBQh8NVddTm6Xa9mdndwTGs79/rRWw9Yt
         qMmVix4ap0MkiOB8Ia78WnvYF84wdztZITWX7I3SV3fVRcaHfuvlBxQBJc3ZmmxNTH7D
         lArHiD0DxV21v5rJI7k0Do8lFAHbX0J6/bGD75AujWRJ1Km72dX5ofW2Z5pSbBm7ZouW
         D88MQLGmgGOHOvQ/0m5nqdkrlAYC5EI7ekuM4lx1nVCqxpxKeRdW+qYOwy1KzS9Ok0Up
         OSzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=F49n0GDWtFmpiEIHBxknxSVaGxbsGKILhJWwZ2t+BIY=;
        b=Fjh0SQGNWmgYf6itKtxFlMcosXga6R+l1RX/A9p4qpidcLdXo6g9zX/drhxZmiFCzL
         qeN2oV+7x4WWBhdbW1vLimRCUsJlVZYK1e3leP3xVaICejfQ9s7rBbfmi3tcaPjUZ2zc
         89NXObCyeFoD4n4IePZAvZ+2lG5mYh/Nl3C+WAN/rEvUA7AN4hncOjaxyMF9H/OxzvMD
         u0qQaddp8sFKjdTnnm79385Sni2g74CwXnj7Ao9S0KTHUx3gR69s30drxLPtRbboCPtd
         oxPK3zyXw+XHl1SuQkkdMubKcV4wIMhlPwAHe61Xm3OUI/CJ40z9K/FhZO3hxg8+GFbR
         5RHQ==
X-Gm-Message-State: ACrzQf2BITLKvmNRD8YX/mDPYvEMu/efK8c6irdnF/OvC1BgCi492j3k
        HEOarayJA7ZMoDIP/WdLzje9Yw==
X-Google-Smtp-Source: AMsMyM76/uCVz6xKwCJLcbvJtMkqSyOKlQalG00ppHsbbHQGAc7sizW1/Mur+gYQepbX3lVr9p2kfQ==
X-Received: by 2002:a17:902:d70a:b0:178:5d52:9e41 with SMTP id w10-20020a170902d70a00b001785d529e41mr104932ply.0.1663796364312;
        Wed, 21 Sep 2022 14:39:24 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id bb11-20020a170902bc8b00b0016c57657977sm2511097plb.41.2022.09.21.14.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 14:39:23 -0700 (PDT)
Date:   Wed, 21 Sep 2022 14:39:19 -0700
From:   David Matlack <dmatlack@google.com>
To:     Vishal Annapurve <vannapurve@google.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
        shuah@kernel.org, bgardon@google.com, seanjc@google.com,
        oupton@google.com, peterx@redhat.com, vkuznets@redhat.com
Subject: Re: [V2 PATCH 4/8] KVM: selftests: x86: Precompute the result for
 is_{intel,amd}_cpu()
Message-ID: <YyuEhxW4URWVvHyW@google.com>
References: <20220915000448.1674802-1-vannapurve@google.com>
 <20220915000448.1674802-5-vannapurve@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220915000448.1674802-5-vannapurve@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 15, 2022 at 12:04:44AM +0000, Vishal Annapurve wrote:
> Cache the vendor CPU type in a global variable so that multiple calls
> to is_intel_cpu() do not need to re-execute CPUID.
> 
> Add cpu vendor check in kvm_hypercall() so that it executes correct
> vmcall/vmmcall instruction when running on Intel/AMD hosts. This avoids
> exit to KVM which anyway tries to patch the instruction according to
> the cpu type.

Out of curiousity, why do we want to avoid this exit?
