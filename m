Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1520323F258
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 19:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgHGRzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 13:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbgHGRze (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 13:55:34 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DBEC061756
        for <kvm@vger.kernel.org>; Fri,  7 Aug 2020 10:55:34 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id e4so1266495pjd.0
        for <kvm@vger.kernel.org>; Fri, 07 Aug 2020 10:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=xkhnD1uY8DPhwyIZWdGamYk5L7D4QfW1rXqEO+V5I1c=;
        b=tz1oZUHf/AbOebVewXDvZPb7obQ7SZQy1vHfBw9QEUYWBBKpm3y8dCiJ/rfzbyI2mo
         AHBXyJ4lUq8+6Rn0wT9bAapx8HpnWLjEHATEjk8Jihfat24Hll2B8nhM5LxAnybMiicE
         m+ZWX5HEesu4P+VyXLiJs5me2g6YUfDiGw9LnUlKY/Sw0Z8NQXr2boPxNNPyTCsZpMFr
         oWWiQ5Ca9EBTR71p6NJHh795snZjOBRzCWxBQW+wI3xGqPLtO4ST79bRpLSb2hK1sNSN
         dtRP4Y2dEu+VrMu9GLTA1+6LTpOIO5AaaH4Kq+KJBLhDUA+seRP9npDtQaXewOnXpvWd
         cOsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=xkhnD1uY8DPhwyIZWdGamYk5L7D4QfW1rXqEO+V5I1c=;
        b=Kb1bccuehuukbVwwFBD0woBicfIZpUZaEDrekClkeWDCtQW2WxuW4gOAc1owpxhHOI
         1Glv/Mvd9eKkQryxUlgJXk9znf5XpT7UoeD/wG3DLdIoS3Nc65wyMatGXci+S3mEi/79
         rBUkIcJnkrZTZPsabhNWmkyBNszrBviPUahwT7IZ0v9SeWS7A0qXrb8MwxlQMCqPC+1Q
         2MNnC0zDw92ks2mKI7h6IBjWRmI84fnHz6W49eqt0PL8R1isE4hQxeVxLj7Yvw/vgTWb
         YxeqoA54HgdZUwbj/LEm0paP92ZjYP8a5dVom84JSwH6Pqi5rHgsrLNzwuQyHkpJs5Ay
         LAZQ==
X-Gm-Message-State: AOAM5336ldgsuBOIGqEN2PCO7ZeMeVsXsqsR6qpuJ1AWAMtRMA7URM7g
        XftFXm8haP7Ql3h6Tgdhb7owlTwdFq0=
X-Google-Smtp-Source: ABdhPJziQEXaNvR5OsR8t+T98b7sxC+ZP0EM2zHuxQOhSYDiauawNqUwmsuuxSTGZvhBEaZytxWcww==
X-Received: by 2002:a17:90a:f313:: with SMTP id ca19mr15112387pjb.226.1596822934273;
        Fri, 07 Aug 2020 10:55:34 -0700 (PDT)
Received: from [2620:15c:17:3:4a0f:cfff:fe51:6667] ([2620:15c:17:3:4a0f:cfff:fe51:6667])
        by smtp.gmail.com with ESMTPSA id p10sm11764652pgn.6.2020.08.07.10.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2020 10:55:33 -0700 (PDT)
Date:   Fri, 7 Aug 2020 10:55:32 -0700 (PDT)
From:   David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To:     Cfir Cohen <cfir@google.com>
cc:     "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        Lendacky Thomas <thomas.lendacky@amd.com>,
        Singh Brijesh <brijesh.singh@amd.com>,
        Grimm Jon <Jon.Grimm@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: Mark SEV launch secret pages as dirty.
In-Reply-To: <20200807012303.3769170-1-cfir@google.com>
Message-ID: <alpine.DEB.2.23.453.2008071055220.2136128@chino.kir.corp.google.com>
References: <20200807012303.3769170-1-cfir@google.com>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 6 Aug 2020, Cfir Cohen wrote:

> The LAUNCH_SECRET command performs encryption of the
> launch secret memory contents. Mark pinned pages as
> dirty, before unpinning them.
> This matches the logic in sev_launch_update().
> 
> Signed-off-by: Cfir Cohen <cfir@google.com>

Acked-by: David Rientjes <rientjes@google.com>
