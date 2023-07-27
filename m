Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B449765B8B
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 20:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbjG0Soa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 14:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbjG0So3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 14:44:29 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7E32D4D
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 11:44:28 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-583c1903ad3so12980347b3.2
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 11:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690483467; x=1691088267;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8L/Vgos6/NaN+zH7p4oLH8zvbyjRWshyuGMcVo8Oclk=;
        b=6XSNkIVg1/ffWwicI/ODXZhUO2IBJpLY5kM5IT7wrcnFTj72snJ6tsuaXhuwXgcZ1K
         Az+qCH6DrVNMVYHGjD0LHgmbaTmxdy1YX3Y+WsQSuRu+YzPEmtEzkTAf+q0QCULBZzRQ
         6lmxo+UZduTVCPH16jMStvrKgOCxxNoHAgg/xwTM45NJW3NXQjJ78PQ3bTkqnA6oEbR1
         XdP/Ozn2PJ8nsHPuXgnNYXv5YhXeqPR5/E+nYpgKoj3uFo4jeW7OMImxDF26b+EXttaE
         JU4PWpFShbhaV1/JfXLu31aVcN92Fqm+oAOwpUQFqEmkqmAliG9iHUwlK6v+4KENeoP9
         NL1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690483467; x=1691088267;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8L/Vgos6/NaN+zH7p4oLH8zvbyjRWshyuGMcVo8Oclk=;
        b=dC0WpWFY5eBQPn91iUlgA6Ff3e++a1fjpm7p7gLDJFOBZYuzBeEzDzzEud7cY0PTWc
         RYHZLSQ9bkqel/z9SomuC+tbk9PPWG8BdgBbqmb651/OTv+fScrAWla/M2iw/4FihABd
         fI70+rsPxGFfBPBQ31qONp4CZGjAbCO0OuvR1ZvRf0PTSV2L0EcywCssXCzj36n/peix
         pEZrLQqNlFrfF8BVVd/5wGGiJjZTo5ocUl3uU5lTIHKPkHbVBEfifishMnTmqx3Dfhj0
         C5HHgYUk7IPT3t+8nheQJpnmQhDqKijD0Qg3V4V8k9zE+F/Ce34Oq0oZ8r2j64SWYtWl
         dlYQ==
X-Gm-Message-State: ABy/qLa5Oz9c5qWe5weAGIwjgKZtGZN/hyIGzuNeeSWmtGQ3z9/X5umE
        pb5LijB+uPmaw0pO88D1Ka6tJO6neDE=
X-Google-Smtp-Source: APBJJlGM7W3HBOUySidGmedDCze7b0RGGIfkhIGdaSljqsKezOMGO0XVEY7JOiDBkoVhVzqHv+oMJbsnhPA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ad64:0:b0:583:5039:d4a0 with SMTP id
 l36-20020a81ad64000000b005835039d4a0mr1982ywk.0.1690483467349; Thu, 27 Jul
 2023 11:44:27 -0700 (PDT)
Date:   Thu, 27 Jul 2023 11:44:25 -0700
In-Reply-To: <CAAAPnDH=42rkUw5noZOFbPYN627+bPiTxfYd5HNfJUT1PBfYjg@mail.gmail.com>
Mime-Version: 1.0
References: <20230607224520.4164598-1-aaronlewis@google.com>
 <ZMGhJAMqtFa6sTkl@google.com> <CAAAPnDH=42rkUw5noZOFbPYN627+bPiTxfYd5HNfJUT1PBfYjg@mail.gmail.com>
Message-ID: <ZMK7CeDmV4okacLl@google.com>
Subject: Re: [PATCH v3 0/5] Add printf and formatted asserts in the guest
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 27, 2023, Aaron Lewis wrote:
> >
> > The easiest thing I can think of is to add a second buffer to hold the exp+file+line.
> > Then, test_assert() just needs to skip that particular line of formatting.

Gah, had a brain fart.  There's no need to format the expression+file+line in the
guest, we can pass pointers to the expression and file, just like we already do
for the existing guest asserts.

v4 coming soon...
