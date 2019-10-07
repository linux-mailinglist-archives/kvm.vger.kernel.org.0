Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1F4ACE11D
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 14:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbfJGMBx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 08:01:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3409 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727745AbfJGMBx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 08:01:53 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BD4DCC057F2C
        for <kvm@vger.kernel.org>; Mon,  7 Oct 2019 12:01:52 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id m16so3227752wmg.8
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2019 05:01:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bsJhXhtGYtCH4CJ8wCC3ALCtO7mJ3gdkqUkiOJ5d8pY=;
        b=kYSuf+eO6LNhrpHidNNdONwlxjEcmqle66I8F/53Py1xJ2z0RZXJrg2aBZGKiGwS5V
         2eDDQWF4khuw4dJO8x+h5GHdqOPwwzBIaf3UxWWmZ/OVSn0XAh07820siSyNchDhQg4/
         1+XA9crT8dB2qFhe6ykCI1ioOV+g8EN2TXtxOBGLkwu5uKr2mc142GCP0FrK0ngULGO9
         NWm/ccI6ebROR7MMcQlJn96J9mQbH85+rwPqlyng94jZyiKnL48ES/uAXTJ1ZjGidhLl
         WPfmw6zOh9KTkeQpeIwVhZRMOavMAP2s2IMypi9uakoMmsdgVXGt4Ex6Vuc5W57D/v0Q
         DfAw==
X-Gm-Message-State: APjAAAWsO4eXaDabk+L0OJ5VbwdWmei/xlSksF3R0mMFDir+aXhFh5w+
        Te26H0+uK5i+jGRHYRrqnue76jirS8qXM/O6nzC/B0xN1AA7g0ZOGLjLg/NmRaAbjH1xUua9Q7v
        U2uPna2+oPcGw
X-Received: by 2002:a7b:c758:: with SMTP id w24mr18575842wmk.148.1570449711342;
        Mon, 07 Oct 2019 05:01:51 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxpkDLI5RBBqDmC0OqrP6lbSm3bJNPcdNP66AeEivRkI32/Jf0wIuKO8BUPPRXP1sZq+LKpHQ==
X-Received: by 2002:a7b:c758:: with SMTP id w24mr18575822wmk.148.1570449711066;
        Mon, 07 Oct 2019 05:01:51 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9dd9:ce92:89b5:d1f2? ([2001:b07:6468:f312:9dd9:ce92:89b5:d1f2])
        by smtp.gmail.com with ESMTPSA id l18sm15770965wrc.18.2019.10.07.05.01.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2019 05:01:50 -0700 (PDT)
Subject: Re: [PATCH 1/3] perf/core: Provide a kernel-internal interface to
 recalibrate event period
To:     Like Xu <like.xu@linux.intel.com>, kvm@vger.kernel.org,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, peterz@infradead.org,
        Jim Mattson <jmattson@google.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, wei.w.wang@intel.com, kan.liang@intel.com,
        like.xu@intel.com, ehankland@google.com, arbel.moshe@oracle.com,
        linux-kernel@vger.kernel.org
References: <20190930072257.43352-1-like.xu@linux.intel.com>
 <20190930072257.43352-2-like.xu@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <6439df1c-df4a-9820-edb2-0ff41b581d37@redhat.com>
Date:   Mon, 7 Oct 2019 14:01:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190930072257.43352-2-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/09/19 09:22, Like Xu wrote:
> -static int perf_event_period(struct perf_event *event, u64 __user *arg)
> +static int _perf_event_period(struct perf_event *event, u64 value)

__perf_event_period or perf_event_period_locked would be more consistent
with other code in Linux.

Paolo
