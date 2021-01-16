Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352B82F8BBC
	for <lists+kvm@lfdr.de>; Sat, 16 Jan 2021 06:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbhAPFmQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 Jan 2021 00:42:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbhAPFmQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 Jan 2021 00:42:16 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEAB8C061757;
        Fri, 15 Jan 2021 21:41:35 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id h186so6874734pfe.0;
        Fri, 15 Jan 2021 21:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DtD+Dq7Ty9GZfLXxJHCqSGUCvbBgWKLNZ+mqGotDTPE=;
        b=o3ittQHJ9qxgP8ozrD9zq/MpgDWH4WaQ/ky9+WpkM1PrFNL/nYYv14i6hibxu0ySof
         PxDEdkODFWCHTu0BCqf8bpzqopkKjdv2ti5/fGs51ExtdwoGjg2+jO6rufqB5bdrEsYb
         zOE7GJGMn4vjBDD3sLmKQzQeSxGJNXftdi6/MsGMeddvWPB+tXMU1KZIbftYNOo98idl
         rVz+NZkNklyAlWkYJDKx0C3fgeTLmLQ9Jc+zl06LoGAYy7WAhf4tEEvlP9TvreHeKy6p
         I+zS8SdGzBzhcpNu7/SfelUCDiQyYJMmeMdH+xToEvjQ2aywY2E9s8Y15NTZanhD4igT
         1M6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DtD+Dq7Ty9GZfLXxJHCqSGUCvbBgWKLNZ+mqGotDTPE=;
        b=c3Tb4jB67JBf3674jHTQMT0hb1ablOrUwfJzF95Zc/Kvyyw5VzFYn8SrYr4N9Xahor
         3TawehTttrjSQd5CAIpKDojEHhBN/aW9UB4dQeIa+mxgklQyKHRfX9At+GHw+DhYMZJ3
         WETsU4sWWXQ9vuQGTtjlNRMlaeH1+PZQqCHFoH4Tmo082KkHTupYOOk8zIHxo9cMXVvD
         Fw/cS69a0Ol06HwAaq6HXPJLRiqXWI0OKFmkZvAMV4VlcuXBF7lkGsmR+cwVT6YYhMnQ
         V2NHrlSyJV7cEY3ehS+uOVmxtMnxGxJhJx9mxbrNFWUmoDWWH2YrW57nXklYgrJgIvf+
         oAdg==
X-Gm-Message-State: AOAM530KzL8jCN6UAr16c8/D9vfHTx7xheKRn+2IkaTOq7ffUl87UwOE
        O6pnaZKhCdRehaDuCBCDe94=
X-Google-Smtp-Source: ABdhPJwaBuBJ2fA1qmUGezrdTxSJbx6e7OfCkpOFQ+cTGxxE1HX9wWJlA2nwohMMr3RbNcx10YO2Ew==
X-Received: by 2002:a62:1b16:0:b029:19e:238:8627 with SMTP id b22-20020a621b160000b029019e02388627mr16370398pfb.52.1610775695149;
        Fri, 15 Jan 2021 21:41:35 -0800 (PST)
Received: from thinkerpad.loongson.cn ([114.242.206.180])
        by smtp.gmail.com with ESMTPSA id l8sm9245975pjt.32.2021.01.15.21.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 21:41:34 -0800 (PST)
From:   Cun Li <cun.jia.li@gmail.com>
To:     vkuznets@redhat.com
Cc:     pbonzini@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cun Li <cun.jia.li@gmail.com>
Subject: Re: [PATCH] KVM: update depracated jump label API
Date:   Sat, 16 Jan 2021 13:41:13 +0800
Message-Id: <20210116054113.117438-1-cun.jia.li@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <87h7nn8ke8.fsf@vitty.brq.redhat.com>
References: <87h7nn8ke8.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sorry for my late reply. Several final exams have delayed me these days.

Thank you for your detailed advice!
