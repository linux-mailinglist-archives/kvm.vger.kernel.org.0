Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E91375561
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 16:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbhEFOGw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 10:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234356AbhEFOGu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 10:06:50 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C856DC061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 07:05:49 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id i8so3101063qvv.0
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 07:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hbjbiDDox/c2hA+feNWa8syDuZOLvvjQadHx48Aoaro=;
        b=LbhnY5ym9APVeexTLuJGr7MMKGjN9hmqX26uD1UJYcMkAkX8z/tiZhK/ikt2rvhzHS
         9kEGmwuk18n4q52jU6YNu0X4xEKX5txN/russqjjG/pLr/DNQHP+bd9jXnjBOKkDwxfw
         nW6pNFM1rHJwQ7MEyYnp3PGBjTOEoM084gYIHzYoYF3NF2GKgPxZG36GlFRNw2lNHEEf
         vbXQMEK2FKKzEtBE/bM3cpjM3guUGn5pJDvrJODg086lIeWMKmtXbfo04kI9i63Rn2bt
         BJRfd6Vd2CEWVhmtLh9Ns2MT31KNfgtMGje83IIQAEhYOmNizIO4tFCX/DDhlrzHTLHH
         nGDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hbjbiDDox/c2hA+feNWa8syDuZOLvvjQadHx48Aoaro=;
        b=BxhPRMV1Dg0IE36WPkMddBu7HiJ6qmyyNAN/uhliNTVWUJaUkTITfH9UMg9xxPcLDg
         ahKLyyMXFFLvz/Jn7zWB9+yFkbOI1E7fszUl2vdCOI7VenaggRlzo8KofikXE3AMqH6h
         t++jwZuDRrkDGlrh7NX5XMSt2GtwIo0aiNjoTKVc+7yhy1XVbt2jH6ASSl5354K7dAnJ
         u1BYCw2cpbbsn03ZCwC42TV7/QCYxjCPQGwLeWdT6kVrwI50oZ+mtY/qzD2C6bnzW2pS
         88BqVwMUEPYRv9YubdoVClZa7F/w2NGajFX1krfkIgV36AV2g11TSBGgYECYR9d8fkTV
         D/6w==
X-Gm-Message-State: AOAM532BwtqtZvr1jQbjqRjWGqsmB8ERJETowb6eJEDb0dVC68fscppc
        T43ikBMOUG4xzckAclqSgiechw==
X-Google-Smtp-Source: ABdhPJytRVmf5ibcwq9QlnppqKcfHA6xaf6/9LV6NnirB+BDs4Bxqg1Q24VuArzOivzw+if6socsjg==
X-Received: by 2002:a0c:9e0f:: with SMTP id p15mr4701467qve.33.1620309949095;
        Thu, 06 May 2021 07:05:49 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:4c4b])
        by smtp.gmail.com with ESMTPSA id o135sm1862762qke.124.2021.05.06.07.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 07:05:48 -0700 (PDT)
Date:   Thu, 6 May 2021 10:05:47 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     tglx@linutronix.de, mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, bsingharora@gmail.com, pbonzini@redhat.com,
        maz@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        riel@surriel.com
Subject: Re: [PATCH 5/6] delayacct: Add static_branch in scheduler hooks
Message-ID: <YJP3uwSWeMUtSYcp@cmpxchg.org>
References: <20210505105940.190490250@infradead.org>
 <20210505111525.248028369@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505111525.248028369@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 05, 2021 at 12:59:45PM +0200, Peter Zijlstra wrote:
> Cheaper when delayacct is disabled.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
