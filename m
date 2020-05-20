Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF53C1DAC69
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 09:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgETHlK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 03:41:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27266 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726435AbgETHlK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 03:41:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589960468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rO9Y5Ec6p6UJIY190OJ9WK4iYIJu0z77oYDvlXTwxpQ=;
        b=fBstCLdFRVDEV9vhTIg2/1Lzk2nXsefwXlm2WBx/QuoaR0zPKGBybFjXExLIkermxI5hSN
        lsRL75A7FIKRjIkianCM0epzwbOqf3G6S2l6rKm2/VBZk6bXulvRiYHe55iMyrmfMwuoXP
        XKNkOQm5NTABY2opqJun5mh5gu/iZd0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-amWoehgBM-OnDGUS8jfy2A-1; Wed, 20 May 2020 03:41:07 -0400
X-MC-Unique: amWoehgBM-OnDGUS8jfy2A-1
Received: by mail-wr1-f69.google.com with SMTP id p13so1040850wrt.1
        for <kvm@vger.kernel.org>; Wed, 20 May 2020 00:41:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rO9Y5Ec6p6UJIY190OJ9WK4iYIJu0z77oYDvlXTwxpQ=;
        b=h6gpjLQ/OEgMh9j58NFb9hAgR+lU3ifui4PKg/lvbkKhIetwCVlu4CKHoB9Hu2SIOp
         Lcq7uHTKS3An4aIDkUaOCl1WmfR2lbuAemhA63DEnH1eUrylslJoOfvsDXKPVKcbI5qJ
         hvyR4KhyqYCkCGR0I8DghnDH/e3yxNvo/OSQtcSprQ2819T+x8o3/T+Tpe4EVPz7FGFR
         E8yxXpXjTyfou4xKrBpo3bGSSNbnEjkpN78wetvou7s0iVCDQMKYkdGRSDF2/LbVRMGw
         Q3KQGsoz2IAw8tmCErWptr/akIBI7AKXAAddZ7BfgeY24BBHtEhpJOwtWYdECoHbnL6f
         4mDA==
X-Gm-Message-State: AOAM533S5GktPhlGomejX4X4wtf1mBpWBypEyRm1SPhoAk8OMHE7MSzJ
        Y2sZd/A+x2HnCUpTOCbCX5/o8tJyFFx1M/Vo4EEkni40ohzqCOD3forRd9l60BxIFeKhOe6J1bL
        FfLD8E2/6mcy9
X-Received: by 2002:a5d:4907:: with SMTP id x7mr2786730wrq.49.1589960466426;
        Wed, 20 May 2020 00:41:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5fXvnE7V9n/E+0RBL3D0zq32eeT6Ow8Y+KKqcAB6ttQ/rkB40H3G29WCFq0hAvGbv+Ccm2g==
X-Received: by 2002:a5d:4907:: with SMTP id x7mr2786711wrq.49.1589960466218;
        Wed, 20 May 2020 00:41:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:591e:368f:1f3f:27d2? ([2001:b07:6468:f312:591e:368f:1f3f:27d2])
        by smtp.gmail.com with ESMTPSA id z7sm1940832wrl.88.2020.05.20.00.41.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 00:41:05 -0700 (PDT)
Subject: Re: [patch 0/7] x86/KVM: Async #PF and instrumentation protection
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, kvm@vger.kernel.org,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juergen Gross <jgross@suse.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20200519203128.773151484@linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dcc0bdab-3d5e-acde-1344-e82f5e84c3ca@redhat.com>
Date:   Wed, 20 May 2020 09:41:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200519203128.773151484@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/05/20 22:31, Thomas Gleixner wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git noinstr-x86-kvm-2020-05-16

Pulled, thanks.

Paolo

