Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9051CBE2A6
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 18:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391811AbfIYQjq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 12:39:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49819 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390809AbfIYQjq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 12:39:46 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B70EF10A1B
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 16:39:45 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id s25so2331187wmh.1
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 09:39:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=50Vof/xPYtVz7iGOHYOjX70wTG84bEtYtfJ3/I0yg7w=;
        b=gQeARaO6V3waHeEo+0VHyCSK3mfXI9ZsvQI47XI7wqJ4DzBFXfwsoixSNzQ9v8Cyyo
         8gz1SIS9DRLgYR1O+3G2y0/bRKdudG+XyVXKWb2IE+NJ1c347vv7JhGOYnsTHRMcGvnn
         q0/E5rjna5PQUZ+bf6R2n4vhtMQcJsrLaVyksndG4OBIH/Q2a+xsa3OHkKyP3/pzTtan
         BY8p4Qu+FKrUmrVDbSWtxA6+DzkZSUEp79cNieNLEV3HgYMF2IFnGQNrzRzLyPjmvtgw
         OB2iOae5LiZ/G8e6v2oZMVwBfUfuJd9Kb8Kg22w6yEucqHYvy+Lm/wmS8DdkAdPnqixE
         D9Hw==
X-Gm-Message-State: APjAAAWUB+yyBE3y3sCCyldflFO9dyFaXu82g3VqJF3ZMCvJse1qESqB
        agcgHbiguY06VYgult8hQMKexHRC4R6ZmlaRK/SGWVz4ayzjkIN5wYuKeF2G/hl8MC/wgJhl5DF
        vbNDEd6GlbRZj
X-Received: by 2002:a7b:c398:: with SMTP id s24mr8910835wmj.78.1569429584309;
        Wed, 25 Sep 2019 09:39:44 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy3hAGmG7sny3t/gkf0jLXWoOxfmJI9kxYj0IFAinLXBdf2BYXvaVt4uuSHr01NMZy5yxW/eQ==
X-Received: by 2002:a7b:c398:: with SMTP id s24mr8910821wmj.78.1569429584045;
        Wed, 25 Sep 2019 09:39:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id j1sm10527158wrg.24.2019.09.25.09.39.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 09:39:43 -0700 (PDT)
Subject: Re: [kvm-unit-tests PULL 00/17] New s390x kvm-unit-tests and some
 fixes
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20190925163714.27519-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <534d07f5-c117-ce4f-ad41-761d1bbdbd27@redhat.com>
Date:   Wed, 25 Sep 2019 18:39:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190925163714.27519-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/19 18:36, Thomas Huth wrote:
>   https://gitlab.com/huth/kvm-unit-tests.git tags/s390x-2019-09-25

Pulled, thanks.

Paolo
