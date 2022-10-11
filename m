Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E236F5FA941
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 02:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiJKAUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 20:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiJKAUl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 20:20:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99247D7B8
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 17:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665447633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rVV+6Wph3bAh4tPNroZhezVIi89kwJLdBTdHtGxU0T0=;
        b=X9pd+nfJ4z8HeQCd9NglpvtpnYtifFz9QxbJEQXKtMKC6WEj1WhSOIWmmoIShAv7E6JRfr
        n6phZ346qfzn+T2USCfumHuwkHNAp8fQZmNKI7qDRVf6CGSxNJ7/eulMxTpdHinc0IkCfV
        AifG+d6Mh+xpYs1Mit7Aq41MWgL/pKc=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-644-aVn56r7WMJujTL6kVp7tdQ-1; Mon, 10 Oct 2022 20:20:32 -0400
X-MC-Unique: aVn56r7WMJujTL6kVp7tdQ-1
Received: by mail-qt1-f198.google.com with SMTP id ff14-20020a05622a4d8e00b00394aaf0f653so7751365qtb.19
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 17:20:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rVV+6Wph3bAh4tPNroZhezVIi89kwJLdBTdHtGxU0T0=;
        b=z/Ijc4nPxka3X2L8Y8YodTTHT1lTrQm8PYlAtvjiIpWktMdhrKKCfbl3U1QL+9CtaF
         QZ3cJTUJJ3Z3RbXkJpmxZLWknBOVShSixOviMVPT1Cuovz7bgEXCyrrcoxjdCuq9S4pz
         oKzi2ER3eWKfvlxAE37pQ0aD/346ZBWyZ3KjkrsT8yGe/pC7iOhyYvx26l/y+VuOo4yF
         UoKLoQE8NuDbJzSzKN0H7K34U8cRYl1VcgnSCovlnLxGQ5lMwdZUILraiGTSY6Wi/iNY
         XTK4iDufR4B6q1bwFLECMT1Vf4Cl4BA5M+46fwx07uWOi9PmsuXaNx6/eTjTnd1TjwEC
         dGYQ==
X-Gm-Message-State: ACrzQf3T+sJMyGKntmg9GYiFwU/v6WWNDmh8zFCCz7r5D1hPr2Zrg156
        VDRbeMyrZfShMeOBiHOZ81PtXgKYtuG5UC4alWHHGhkZvNahH/vXCxGbtkc0C05bxO8b+JiGKMg
        KoCTffxtpxW8m
X-Received: by 2002:ad4:5c85:0:b0:4b3:cac2:d5c1 with SMTP id o5-20020ad45c85000000b004b3cac2d5c1mr13650806qvh.116.1665447632104;
        Mon, 10 Oct 2022 17:20:32 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4APqlKaeubLmKzZv8PniURDxG3Aan94kqA3Nfb19HmD+OXgHG0Yf2LeCneMPb1rOCBmvdDWg==
X-Received: by 2002:ad4:5c85:0:b0:4b3:cac2:d5c1 with SMTP id o5-20020ad45c85000000b004b3cac2d5c1mr13650793qvh.116.1665447631931;
        Mon, 10 Oct 2022 17:20:31 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id d12-20020a05620a240c00b006cf8fc6e922sm11430594qkn.119.2022.10.10.17.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 17:20:31 -0700 (PDT)
Date:   Mon, 10 Oct 2022 20:20:29 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
        andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
        pbonzini@redhat.com, zhenyzha@redhat.com, james.morse@arm.com,
        suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        seanjc@google.com, shan.gavin@gmail.com
Subject: Re: [PATCH v5 3/7] KVM: x86: Allow to use bitmap in ring-based dirty
 page tracking
Message-ID: <Y0S2zY4G7jBxVgpu@xz-m1.local>
References: <20221005004154.83502-1-gshan@redhat.com>
 <20221005004154.83502-4-gshan@redhat.com>
 <Yz86gEbNflDpC8As@x1n>
 <a5e291b9-e862-7c71-3617-1620d5a7d407@redhat.com>
 <Y0A4VaSwllsSrVxT@x1n>
 <Y0SoX2/E828mbxuf@google.com>
 <Y0SvexjbHN78XVcq@xz-m1.local>
 <Y0SxnoT5u7+1TCT+@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y0SxnoT5u7+1TCT+@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 10, 2022 at 11:58:22PM +0000, Oliver Upton wrote:
> I think this further drives the point home -- there's zero need for the
> bitmap with dirty ring on x86, so why even support it? The proposal of
> ALLOW_BITMAP && DIRTY_RING should be arm64-specific. Any other arch that
> needs to dirty memory outside of a vCPU context can opt-in to the
> behavior.

Yeah that sounds working too, but it'll be slightly hackish as then the
user app will need some "#ifdef ARM64" blocks for e.g. sync dirty bitmap.
With the new cap the user app can implement the whole ring with generic
code.

Also more flexible to expose it as generic cap? E.g., one day x86 can
enable this too for whatever reason (even though I don't think so..).

-- 
Peter Xu

