Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC1448CC20
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 20:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356437AbiALTjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 14:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357210AbiALTjC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 14:39:02 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73689C028C3A
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 11:38:45 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id oa15so7170531pjb.4
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 11:38:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qzu0W7luXmF5PYf8DA5sImzBEUVSK6W0gLuKzPwx89s=;
        b=hH6ZJY2CsrPwl3tONEith676vxb02h20i3jmc8hx0sTaH+bHym4htb9alJoEJJCl7c
         Dlcj/hfBD0kzusT+RxNuEBtWg6iVoRCnDFCJGlQ3v895jIQGGiVufz+oO4kEYC0x/9nA
         D+SkcO7mKyJKTd3j2GwRt9vmo0tt5MX/CMvjZvrMAGefyH4M1Wwchr6JT1NoUX73z4Wv
         YrT++r4gVE8jXQXGN5PvU/aImNF9K3DdaNd+ZrZKPubOy2mVda4R5Nck9rJGn/HluyOU
         io0am+EY4E64PuPLwNJ3syCZ64gzizoMG6xQ7pIwBMajUXnB8qevDlOZ0jG5XIfbFsvp
         XYyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qzu0W7luXmF5PYf8DA5sImzBEUVSK6W0gLuKzPwx89s=;
        b=KFmI/rkEB0ZlUS7jqHSdqZgGtQfsm9quP+TGbkIbPf5OcbOHug6M2ePa3O5MJ7pQeD
         BhDWPZ2l3Ge56oYvyyXu4+vp8IHVXMNU+tlWJUax12JZpmfeAxFaaVuJbMo3u6maDKBb
         xE+BMna6oFqhe58oBK1s5hNIgxuWOU83Z3/q31X0+Y+eGE6GYmflA4tA0VZ13MKeD0TR
         OFIjzS3hV2s0o/alHsKHjiYy6zgGe57q9rx06jTS4FRAaTb4TZ2bchO90807GSk0Vxkv
         PxRf+fFzB3sHWT7C3/ObeSq0l1ykb64DC9zyPJk3UzQTSLD1HoeNS1ag4cTgqA40NTE0
         aJwA==
X-Gm-Message-State: AOAM5324T34OXcnQtVV3J7ic7A0lOG0SveQ3xVdo508Q2suFQAmRdRw+
        kr98JougYcTR0iBmOCbd3IRZgmvHhOZZVg==
X-Google-Smtp-Source: ABdhPJyjIQbcDdCBKu7Z+ED+nYeWFReiIU904VhCd/11XMrcPXjIegV+a/Xgy5xbOEC8uBA90zUKDQ==
X-Received: by 2002:a17:902:e808:b0:14a:5ab3:ae6 with SMTP id u8-20020a170902e80800b0014a5ab30ae6mr986799plg.32.1642016324788;
        Wed, 12 Jan 2022 11:38:44 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a23sm398721pjo.57.2022.01.12.11.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 11:38:44 -0800 (PST)
Date:   Wed, 12 Jan 2022 19:38:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [kvm-unit-tests PATCH v2 2/4] x86: Align L2's stacks
Message-ID: <Yd8uQLYAhSppgW74@google.com>
References: <20211214011823.3277011-1-aaronlewis@google.com>
 <20211214011823.3277011-3-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214011823.3277011-3-aaronlewis@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 14, 2021, Aaron Lewis wrote:
> Setting the stack to PAGE_SIZE - 1 sets the stack to being 1-byte
> aligned, which fails in usermode with alignment checks enabled (ie: with
> flags cr0.am set and eflags.ac set).  This was causing an #AC in
> usermode.c when preparing to call the callback in run_in_user().
> Aligning the stack fixes the issue.
> 
> For the purposes of fixing the #AC in usermode.c the stack has to be
> aligned to at least an 8-byte boundary.  Setting it to a page aligned
> boundary ensures any stack alignment requirements are met as x86_64
> stacks generally want to be 16-byte aligned.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
