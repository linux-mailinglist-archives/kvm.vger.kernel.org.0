Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33C72525493
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 20:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357543AbiELSTJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 14:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357537AbiELSTF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 14:19:05 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1401E1312B9
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 11:19:04 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id n18so5694777plg.5
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 11:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dNyZ9T+dUYwRwkaBjj9l280QphHJNrxjD+CcZQQpk3Y=;
        b=Ar50RdeePk5czVD0jatXgPrjfjIwXy2E3NOcDPgyR/5BrThqn3ki5rO4VktXqGIlv5
         eJ5Ej6LXK+cnSNR5BtL6fw1+ENEpfLa1UOtGufZevs5gJZvJ4eUIRYW7zrbNy2nbNN2W
         tnqItekK/Uck6EbhPl6Bl8/VqHHc2YeKFzEOoTW9IAEXNUkBX+OTxUrlti87fm5JzQO0
         xE0fFilwWayRLWapRpiiMo7PXz4iTpcdccchPnTb01tDEsbflUeP3Lv5CSjT6/6S/HBZ
         bJmWyIhq5TRGY7tdhtOrNS5i9AxSvcODtGqptHpJ1RALgOhoBNWKiiYMxOFAPIDWelRT
         OwDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dNyZ9T+dUYwRwkaBjj9l280QphHJNrxjD+CcZQQpk3Y=;
        b=5rFAi9s8Df6CGyu4Xk9W7vGGNUOY9bZUsAEhVtHw0+9QG+9tDz3OM2qara/kecCApO
         DsUfx2PEEDpgALhY1Abc8cObHYZCfCd3R7hphNjosJPXb0OlgbWOQEjFTAwBEn6AHfCF
         G8nurO5rl0JITFhmW8U7E6VN8vqZnNwiI/J9QDT5K3Q5NwWoZBk3F7/BZooBTddlp9AF
         UbloqTbcFWuqTYNTZyeX2qp5nCCY6us6yWdfy5yGiBaCcffLrMVFRo/BH8kLlk/HlJDQ
         v6+IXN4YJhGi9Ejbhi39vCSaXWDuqydpCcjUVz67m1XYdCgAApWm/erFHBqYSQassV7W
         JGPw==
X-Gm-Message-State: AOAM531N45Hd3imNPyufbd9d/DI+TrzkJPEnjc7lyft+NNAyKtLqBEql
        i5djXsg87VxGP41ruNnDq5Rfi7NM/8Z+yn2xZRA6YA==
X-Google-Smtp-Source: ABdhPJwspxnY6WR+5als0TwHPBjHCh/04nW5WS6SVWpGf2Dn5Wh7nyJvLsp3iUNwFbFfnB9AdgZYEPmBILl74wGezlI=
X-Received: by 2002:a17:902:d552:b0:15e:e759:cd38 with SMTP id
 z18-20020a170902d55200b0015ee759cd38mr1095745plf.87.1652379543212; Thu, 12
 May 2022 11:19:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220511000811.384766-1-vannapurve@google.com> <e4a84dfe-2397-0881-b6bd-1cb2b2d5904e@linuxfoundation.org>
In-Reply-To: <e4a84dfe-2397-0881-b6bd-1cb2b2d5904e@linuxfoundation.org>
From:   Vishal Annapurve <vannapurve@google.com>
Date:   Thu, 12 May 2022 11:18:51 -0700
Message-ID: <CAGtprH8YoGsG-0jufYAMMm-a2On4hN8==sNm_oOEmv9jqZZdLQ@mail.gmail.com>
Subject: Re: [RFC V2 PATCH 0/8] selftests: KVM: selftests for fd-based
 approach of supporting private memory
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        dave.hansen@linux.intel.com, "H . Peter Anvin" <hpa@zytor.com>,
        yang.zhong@intel.com, drjones@redhat.com, ricarkol@google.com,
        aaronlewis@google.com, wei.w.wang@intel.com,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Hugh Dickins <hughd@google.com>,
        Jeff Layton <jlayton@kernel.org>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Jun Nakajima <jun.nakajima@intel.com>, dave.hansen@intel.com,
        michael.roth@amd.com, qperret@google.com,
        Steven Price <steven.price@arm.com>, ak@linux.intel.com,
        david@redhat.com, Andy Lutomirski <luto@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Marc Orr <marcorr@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Peter Gonda <pgonda@google.com>, nikunj@amd.com,
        Sean Christopherson <seanjc@google.com>,
        Austin Diviness <diviness@google.com>, shuah <shuah@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 12, 2022 at 11:04 AM Shuah Khan <skhan@linuxfoundation.org> wrote:
>
> + shuah <shuah@kernel.org>
>
> Adding  my correct kernel.org address. Please make sure to run
> get_maintainers.pl to get the right addresses for miantianers.
>

Thanks Shuah for the feedback. Apologies for the typo in the email address.

I will address the comments in the next version.

Regards,
Vishal
