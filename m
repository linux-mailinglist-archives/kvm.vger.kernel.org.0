Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665381BA5A7
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 16:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727808AbgD0OEh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 10:04:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51453 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727010AbgD0OEg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 10:04:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587996275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BrvrKt3lcgt1HQz9prUBfez1RAn+QDtDA7uo58Xxz4g=;
        b=hYTuk85puu9U9cQJdN+SGSfYIiSNHksJn0AT+8nNpBVqwFXnQvFPY1OS3x9XeSVg2JcZWC
        6tySbHjuSlev2/eTaRq0tPiu4znKh2if5ggLN9SWEJd0vU9iFlhn45Z+9ZpT9C7CBoXCtQ
        QvWtB2+qMrgCOIfz0kXgM0b7TXyoexw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-F1OAQqudNSucSTTRY8EmNQ-1; Mon, 27 Apr 2020 10:04:31 -0400
X-MC-Unique: F1OAQqudNSucSTTRY8EmNQ-1
Received: by mail-wr1-f69.google.com with SMTP id j16so10514370wrw.20
        for <kvm@vger.kernel.org>; Mon, 27 Apr 2020 07:04:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BrvrKt3lcgt1HQz9prUBfez1RAn+QDtDA7uo58Xxz4g=;
        b=q6H1oD9d+clWBAT3fHECxPdW2Yw8MIhKkN0OMs/bNyEDx1KAkLM6TYcMcvA5yUoS0L
         3xYwhVhgfizwMN7nvp6JxtkSFAIU85eWaltfdmVvSNIpbc5GZphTI/g61Nm6eVPbffUI
         J7PPTeEQmR0U3xo4tP2ZuQhgYv1oi+VfYQ3udSq2DaMjqISPlCYFlKjX7dLlFRCjP8nn
         /lxc6GEj0OUBX7c+lPf4CJ95eu+n4KBauUHw5LIlbifH0h+amgY+vSFd4lnAS3xvwUwc
         jeJwuC03C9YlI5iWFoM0rYYImPPSwDsc1tFBQZhxcRt99twicvCSvcUrBApxjPur62cf
         UNlQ==
X-Gm-Message-State: AGi0PuaQb5Yl7T0tvYBuz7GT0bM+g7HFd4/4yRpMGn3uhTsBTJ1RIgY8
        wAOgyskqQPFB5dJYMTAc6qttCFlZcBm9Fk5VVn/9LZp60x60pI+qZ8FPnzsn5+PPBQ3f2B22b8e
        bB8ew6oJSawz/
X-Received: by 2002:a05:6000:14c:: with SMTP id r12mr26619587wrx.62.1587996270587;
        Mon, 27 Apr 2020 07:04:30 -0700 (PDT)
X-Google-Smtp-Source: APiQypKQDLpBQhVqSDdEDXl6KFsiycuukhP26/pM6x5dap/F9Yshz4GKOD6lHlwRJje3RKxH/H6HIg==
X-Received: by 2002:a05:6000:14c:: with SMTP id r12mr26619567wrx.62.1587996270350;
        Mon, 27 Apr 2020 07:04:30 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id x18sm20892100wrv.12.2020.04.27.07.04.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 07:04:29 -0700 (PDT)
Subject: Re: [PATCH v11 7/9] KVM: X86: Add userspace access interface for CET
 MSRs
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-8-weijiang.yang@intel.com>
 <08457f11-f0ac-ff4b-80b7-e5380624eca0@redhat.com>
 <20200426152355.GB29493@local-michael-cet-test.sh.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f6f8cedf-26ce-70b4-2906-02806698d81b@redhat.com>
Date:   Mon, 27 Apr 2020 16:04:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200426152355.GB29493@local-michael-cet-test.sh.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/04/20 17:23, Yang Weijiang wrote:
> What's the purpose of the selftest? Is it just for Shadow Stack SSP
> state transitions in various cases? e.g., L0 SSP<--->L3 SSP,
> L0 SSP1<--->L0 SSP2?

No, it checks that the whole state can be extracted and restored from a
running VM.  For example, it would have caught immediately that the
current SSP could not be saved and restored.

> We now have the KVM unit-test for CET functionalities,
> i.e., Shadow Stack and Indirect Branch Tracking for user-mode, I can put the
> state test app into the todo list as current patchset is mainly for user-mode
> protection, the supervisor-mode CET protection is the next step.

What are the limitations?  Or are you referring to the unit test?

Paolo

