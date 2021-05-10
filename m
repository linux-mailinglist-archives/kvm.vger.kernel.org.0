Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E686377E78
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 10:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhEJIrI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 04:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbhEJIrG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 04:47:06 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126F1C061573;
        Mon, 10 May 2021 01:46:02 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id u25so2212653pgl.9;
        Mon, 10 May 2021 01:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FUBCVHj2wA6Xuvvez5hR6gEY9E3AwdDXV1o9Y3URkng=;
        b=EUgd5yVr88TjtWLpfvvqODOhp/wm8nD2j3DNHU66JJmOml629JmxwUhqhqlLtbsewy
         wdsKrr85gK2JfSVTBLxLkQSIoW9gI/fzQq75uHEVb0ADAVUQz2g+zIcHq4210saDz9GN
         iGPXXHpldfk+X4eCdjZ/PxOHhwOeYEBdSa2Ln3JbcjzKJGDAjON0x9pdSqgE8SuDUtn8
         8Qc8/qB3DlHzjPsIbPI224kra7Fka3x+FCVOabG0ij3356rgJF8zr/XUW05h/bKyH8Z0
         0L3IlUlPLChlz+423Y1wGITM1hWz6X6Tgx9aETEbRa0q7nwiTYEcMTUEnUJ5XQSyuR2j
         TqsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FUBCVHj2wA6Xuvvez5hR6gEY9E3AwdDXV1o9Y3URkng=;
        b=QiGIp/iclV4wdcb8eVGwvihvevO+8bCqeEjGlDNJKxwbQytpBrP3aMOJIP9+bzVm+a
         wyZtfybqnlj8cvYM/9ZtYkaqfHf6LPlnOq4mDglOkIzQVMb0EF+/CKnqTGI33pmeR2zq
         4iffEb73xR9Kso9mPTfNyINgQWq/t6Ru5qqDD3huzm5w0iB8PsBEDe5bl8giBDKWCjXK
         G0Hn+fOae2OySszercz/dBwCVd26mDcJ65FBlMdI3vmRieRTP5DqYKQ6VKt+7FLKYYo2
         mEn3BriYLrfBfBzjVeH02BLY5ZGNGY9mwkdwrD8oSQkiARwUphmT3m3so+MCi9jOwNMQ
         Nf1Q==
X-Gm-Message-State: AOAM53025wZItBEAupvwKHktmjtrOPGxkO6Ngxw++qkfOuS8Db3PyBSV
        MeVsFFNYuHDzfgKT19C8vHM=
X-Google-Smtp-Source: ABdhPJy7llcstzsVuH2hHVxeyCUmsPHboPcX4RgH+lzOhEZDxKc/qnRs0jowGdF2x3ADnboATAO/ag==
X-Received: by 2002:a65:4548:: with SMTP id x8mr24021858pgr.413.1620636361559;
        Mon, 10 May 2021 01:46:01 -0700 (PDT)
Received: from localhost ([203.87.99.126])
        by smtp.gmail.com with ESMTPSA id h9sm10185070pgl.67.2021.05.10.01.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 01:46:00 -0700 (PDT)
Date:   Mon, 10 May 2021 18:45:56 +1000
From:   Balbir Singh <bsingharora@gmail.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     tglx@linutronix.de, mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, pbonzini@redhat.com, maz@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        riel@surriel.com, hannes@cmpxchg.org
Subject: Re: [PATCH 2/6] sched: Rename sched_info_{queued,dequeued}
Message-ID: <20210510084556.GF4236@balbir-desktop>
References: <20210505105940.190490250@infradead.org>
 <20210505111525.061402904@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505111525.061402904@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 05, 2021 at 12:59:42PM +0200, Peter Zijlstra wrote:
> For consistency, rename {queued,dequeued} to {enqueue,dequeue}.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---

Acked-by: Balbir Singh <bsingharora@gmail.com>
