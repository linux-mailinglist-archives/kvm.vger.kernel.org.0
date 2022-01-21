Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B35F49640A
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 18:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241855AbiAURjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 12:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242179AbiAURig (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 12:38:36 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278EDC061747
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 09:38:36 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id n16-20020a17090a091000b001b46196d572so9688957pjn.5
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 09:38:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u4Z/nSzdHrBrcg5tzvHVtsO1iIu/GbCLjkELUJQv/gw=;
        b=Bz5Lsfe3X7dWCiHwbzCzT80AjQAt3TWNvVROnXCwgWSj5d6LUTcgQRNsaxeshFgGCR
         0GSiSwDn8/gbLHj25c68Ce45kbe4Ot89SgUP3Hs6pm4inVM5HO28KRYwHRVDEDrv6um6
         /fp9m7jbOyHVt6pH+1GD39MJfw++45WraudsL3ao20sHU2vcca6KcKtu+0+VJoH4mF3a
         FGuh8D7sJ8f1jbX+2ev6dPXTD66FcJPrzorXjp/MJe7yavJYgBs8aTOQ1lN1aZO4BhTJ
         VHLEkckdcsyqQSI+x3ko00Fcby1QzlMHUn242guKJ6QtzAdbxD6RMcLpJvgZ93niAXaF
         OL3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u4Z/nSzdHrBrcg5tzvHVtsO1iIu/GbCLjkELUJQv/gw=;
        b=Oq6OmOutJgMI8L1AfhShLc905bkfnqpEkZ6RjkVFvNxvpgr712+SRtkv6jDRNlfVDE
         nEHTGE+dIZ3Ax7Ze6QQc377g4/QjKj1DZgZhFcAw/lOaO3aFBlK5zdPIJies+o1W7T+G
         Ll1ftXKoY21yMYziq5du99x2x2gJDdn3G6q7WTZ2gUPRZWaoyf6SIF3OIDhJYqhNT2xY
         WKQt5QGQXVi5Bw2/RSLVogG0oV5SqEwVVofo4mVoUh98vAsG4e54lU68l5agJr5y3IaV
         md982F87eSbpqAENyegjdDoseJTPXPT6yfrgwxBd54WpiCaCAqptmpgUa+Y76dbtiAn5
         zmJA==
X-Gm-Message-State: AOAM532UH4IgytrGsBMlEavvveEnE2s6KpzvmkyDlCWHGt9f1W0Nym8n
        K4Gvd9wAk6zl9sIUojm3tL4WPw==
X-Google-Smtp-Source: ABdhPJyMLA61p3HtsaQOMBBKfLjg7KIWIGt7uWGCToCxQOtBTr5moBiP3laP+9jyUG4P/8ZzEKhLrA==
X-Received: by 2002:a17:902:c94c:b0:14a:7ad9:8067 with SMTP id i12-20020a170902c94c00b0014a7ad98067mr4805206pla.104.1642786715500;
        Fri, 21 Jan 2022 09:38:35 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p18sm8414100pfh.98.2022.01.21.09.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 09:38:34 -0800 (PST)
Date:   Fri, 21 Jan 2022 17:38:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [kvm-unit-tests PATCH v4 1/3] x86: Make exception_mnemonic()
 visible to the tests
Message-ID: <Yervl+w0QuA3nRJf@google.com>
References: <20220121155855.213852-1-aaronlewis@google.com>
 <20220121155855.213852-2-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121155855.213852-2-aaronlewis@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 21, 2022, Aaron Lewis wrote:
> exception_mnemonic() is a useful function for more than just desc.c.
> Make it global, so it can be used in other KUT tests.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
