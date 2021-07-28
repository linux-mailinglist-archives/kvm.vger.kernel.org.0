Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E883D9315
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 18:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhG1QWW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 12:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbhG1QWW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 12:22:22 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0944C061757
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 09:22:20 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d1so3333229pll.1
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 09:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SX77jUngzbzpeyvU9f3wQNjCF2DwI9f6Oq2Toy5MXcw=;
        b=KvCtjpjMprp7cO4bWkJe1GwIb9HVJ2dQsU1C+zOdylAGzcWlN3EhgUY05GiYpg8GS3
         BmefgJlebXvJ5bk14+kQbwNBTq8N9gZr03qwY1IcgaEtLX8kdQZaLlzjeU/pmLw8Ew+I
         DTxjfJYAbJY9HIGWtbcauxW7y9VMia9m2VvJ8LRdJc3+17hBm+tvRxtzrgXc8QnvYdRj
         TiPyoB7KDSBPdgMeiXEeH96EXCyjCBoN3UuLVr08WF6yDYILoZkEVItsv/MpgdoBfAZw
         WglAeZeWJPaeFTwduFE9cRL1lR5XyC93A+NiNQWZ6KGm7vf8PaKSawHvIt45W380Aee0
         dqWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SX77jUngzbzpeyvU9f3wQNjCF2DwI9f6Oq2Toy5MXcw=;
        b=ac4epqtMVHiaZFcmHXcrC1DgU/Zd8O/rHl512bE3qX+CrejA+Ic8rbsL6fOSTUMcoG
         4naJny2yGYRgsfcdm923qddAQRahdQOifeyCrxI7/oouzDbU/FRJU7B69tKJa2yjaFHU
         boSp0c3cXYaY7fA4OJGpouwYRUZaqyZJGtYFmkKOEMFid7drYQCrTpM/kaV5vnCEPrlw
         CoYptiQhbEePVuJju0sOo0GLfNDo/7Melz6O8SCwiaF7i2JnvjCCNbjn9ZXUbw6Cz/cO
         74E9ditWdbA713+V4TJ6pzvl1aH+cUidqUmIQeyS0fKDOSD5MQGOzkVUZgj2bOjEfm+T
         gZHg==
X-Gm-Message-State: AOAM533K5KKPhiaAiUHK75IbcnXmYfBYQXZI6116Jobt2HlpDARMlG/S
        i7PLmAunOikQhKuLkLiammi3bbXLI4NY2TeT
X-Google-Smtp-Source: ABdhPJzA3BBIVd+9l/f7oVcmDvOuujhZLkKM56p3RvSH0xXZBMYNJVzR1k+d0z7H+GLq/tOjM+IbYw==
X-Received: by 2002:a17:90b:248e:: with SMTP id nt14mr606301pjb.144.1627489340043;
        Wed, 28 Jul 2021 09:22:20 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id a4sm517203pfk.5.2021.07.28.09.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 09:22:19 -0700 (PDT)
Date:   Wed, 28 Jul 2021 16:22:15 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 0/6] KVM: x86/mmu: Fast page fault support for the TDP
 MMU
Message-ID: <YQGEN9/IXi/BcLJ3@google.com>
References: <20210713220957.3493520-1-dmatlack@google.com>
 <d30ba4b6-2415-4386-6036-9ee2be8a97c0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d30ba4b6-2415-4386-6036-9ee2be8a97c0@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 26, 2021 at 03:50:58PM +0200, Paolo Bonzini wrote:
> On 14/07/21 00:09, David Matlack wrote:
> > This patch series adds support for the TDP MMU in the fast_page_fault
> > path, which enables certain write-protection and access tracking faults
> > to be handled without taking the KVM MMU lock. This series brings the
> > performance of these faults up to par with the legacy MMU.
> 
> Queued, thanks.

Thanks Paolo. I noticed on PATCH 3 you changed the if-return to if-else.
What was your rational? (I want to make sure I incorporate it in future
patches.)

> 
> Paolo
> 
