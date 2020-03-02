Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52595175FAE
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 17:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgCBQbh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 11:31:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35116 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726831AbgCBQbg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 11:31:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583166693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1x0ZM1xTpaIkqmKsVKdQPlGDF0qsj8hnKJSTjUcj/Aw=;
        b=fQHBlnMEnRTtk57rFCbGRNAJeb95rlHRUmHhVDb2JnxLPROTFI86Wy5Xqm+kasmIIU+fFd
        D8aCD1SzRF8ygVgZbiDyBFo99EooI91l5ZC7HOFO6FVUMBlIHx3sVQOORYyM1M2bHS4ddd
        BjT0gU7IF4lkZ4F8YxOoKduimAtRqys=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-nxtdlE-gOdiwg9WcbJavTQ-1; Mon, 02 Mar 2020 11:31:32 -0500
X-MC-Unique: nxtdlE-gOdiwg9WcbJavTQ-1
Received: by mail-wr1-f72.google.com with SMTP id m13so6044440wrw.3
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 08:31:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1x0ZM1xTpaIkqmKsVKdQPlGDF0qsj8hnKJSTjUcj/Aw=;
        b=BfLzQZFyDqpguOV9vmY/Qkk6RYNdQEz42n1PflSWSEjRqoKX6TIBgsfVMmTUjKZ6LP
         eonX4t/lirDe19AgbBuRJ1ajxnVyJTU8BdLCwydawOYb82KIy+kKXO1JWV8ZLfHtKfZV
         ZzyKzD0C5XWcRVCgLNB6KJLZd2J1HeTjMFyR8Dcq88B0vhGP4u6MdWmjiIGd+bBunQq+
         inI4qX2ntbPbQeqsTIYVzLCuWRtY8BMcDvrtJI7ENlB9b1iEpUHoP7y5sY434+SLeMtA
         6rp4L5i+TiU4nvGj4Vs1HL6455STR58nZ44DGtJR11RG2QN6Isdm5goNCE+4+fbXyYIp
         UABw==
X-Gm-Message-State: ANhLgQ3ckvdnthcJwD9IL0nZnG3gvrIwtq28MMX125GQsHZfbYbg4Xvw
        sQfEtkf+TSzXMWTj1nIF+T2VP+9mqZJ8IHeZdnoxpE9LkecijTa+1VlSOcvaRTpo96DKlazhqTm
        z8hcHkYMxhMu+
X-Received: by 2002:a05:6000:100d:: with SMTP id a13mr397869wrx.330.1583166690989;
        Mon, 02 Mar 2020 08:31:30 -0800 (PST)
X-Google-Smtp-Source: ADFU+vuDxQ+If1BB45iLB/FVzoEXWJKceXWuH/ax1Em/rcRFrXJ3iyu6XLdz3lh8x4VPNI6aPabRng==
X-Received: by 2002:a05:6000:100d:: with SMTP id a13mr397846wrx.330.1583166690776;
        Mon, 02 Mar 2020 08:31:30 -0800 (PST)
Received: from [192.168.178.40] ([151.30.85.6])
        by smtp.gmail.com with ESMTPSA id s22sm15544619wmc.16.2020.03.02.08.31.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 08:31:30 -0800 (PST)
Subject: Re: [PATCH v2] KVM: X86: deprecate obsolete KVM_GET_CPUID2 ioctl
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linmiaohe <linmiaohe@huawei.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <1582773688-4956-1-git-send-email-linmiaohe@huawei.com>
 <87ftewi7of.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6c78b2c8-98b2-a517-4426-511505ff9018@redhat.com>
Date:   Mon, 2 Mar 2020 17:31:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <87ftewi7of.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/02/20 12:36, Vitaly Kuznetsov wrote:
>> -		if (copy_to_user(cpuid_arg, &cpuid, sizeof(cpuid)))
>> -			goto out;
>> -		r = 0;
>> +		r = -EINVAL;
>>  		break;
>>  	}
> Braces are not really needed not but all other cases in the switch have
> it so let's leave them here too.
> 

We can remove the case altogether.

Paolo

