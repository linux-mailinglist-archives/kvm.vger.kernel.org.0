Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7DB166353
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 17:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgBTQk4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 11:40:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36245 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728133AbgBTQk4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 11:40:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582216855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j1KjpN5A7zvbASqry7eYUQpd0Q3bBTUxqDW1jw87fwY=;
        b=NhyKenzVmVaFtYLO/yehDGhb9gCxjYPEgbkYoGgvgBP8KbKpsE1Tbf4HoJ1qjJm8V3Szh+
        u20J6a/PkbhlgTjexL015I3riKuiF+DH4oTo0xu2vroyBzxbek5IiWcZN+0VoRK+BjUY4M
        dfOTnpAb++lvsYwWGJTkRX+U2JMREcU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-nnFOkumkMi6UkynroOzmBw-1; Thu, 20 Feb 2020 11:40:53 -0500
X-MC-Unique: nnFOkumkMi6UkynroOzmBw-1
Received: by mail-wr1-f70.google.com with SMTP id w6so1976024wrm.16
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 08:40:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j1KjpN5A7zvbASqry7eYUQpd0Q3bBTUxqDW1jw87fwY=;
        b=n/5m/zkZvfvGfMBggrqB0alD/GKB+VvQ1NL9GZwci7CAtPmTwXgD4expa8ffJc2kbf
         4Sy3E5KXVJ/GrHTDDhbnyHegZpC/w0aaSQyqqvmXjZIPrghAwmom3iNm7+OOcccoXtDX
         qyWxyIfZrO/UJyabRVAHKZItyCo28OYaNpZMwolEY2jFIlugQ807tnk+fWZvtsMbUZWC
         pP9Nb9XkxXOtsBPbHIgb2v/1QMi+k5b/9iTrkqmnOq2M8YtPg3DbURN/Yfv0tVLvJUBn
         O96Z5Hd9nPo2cjBpgNX8G9xCoXyKYY/v8Txfv7nX3gFGsWQCHlpRPX8LIQVHKdy+h1fd
         14nw==
X-Gm-Message-State: APjAAAV0HMBKnYkcfoqbVSufisfzc0C7CxV+MTYcdya4DYKhcgx+yx0M
        6x6mo477FMzBlVgs0NMZEoa1UF5RtI0VUgqO+dVQKhFjJmBDhFSe/w8ZqKKjYLdBjhEg36r1teN
        YCTUFz2A+Ybf8
X-Received: by 2002:a1c:e007:: with SMTP id x7mr5282680wmg.3.1582216851634;
        Thu, 20 Feb 2020 08:40:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqy+shtKDoYKDBEKp6zVovZCoUfcXtnuVjTyk/HxWVXuFi4ny17wNuEuwKg6EMZBnNilnpTNnA==
X-Received: by 2002:a1c:e007:: with SMTP id x7mr5282661wmg.3.1582216851445;
        Thu, 20 Feb 2020 08:40:51 -0800 (PST)
Received: from [10.201.49.12] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id v5sm73586wrv.86.2020.02.20.08.40.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 08:40:50 -0800 (PST)
Subject: Re: [PATCH 02/13] fixup! KVM: selftests: Add support for
 vcpu_args_set to aarch64 and s390x
To:     Andrew Jones <drjones@redhat.com>, Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, Peter Xu <peterx@redhat.com>
References: <20200214145920.30792-1-drjones@redhat.com>
 <20200214145920.30792-3-drjones@redhat.com>
 <CANgfPd-zr3joOCAmW4a0MO7MjYTowYv5r4wxAMo7ddPhhumssw@mail.gmail.com>
 <20200218173841.llr73vagnviejmuu@kamzik.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4f246e81-718e-43dd-991e-e8f5d1d3c2c1@redhat.com>
Date:   Thu, 20 Feb 2020 17:40:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200218173841.llr73vagnviejmuu@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/02/20 18:38, Andrew Jones wrote:
> For me the code makes that super obvious, and I prefer not to describe what
> code does. Also, I'd put these type of comment blocks, written more
> generally, in the header files if they're functions that are implemented
> by all architectures, rather than duplicating them in each source file.

This makes sense.  For now I've restored the comment, but moving them to
the .h files is a good idea.

Paolo

