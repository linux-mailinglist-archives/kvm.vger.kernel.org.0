Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE3119ACC3
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 15:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732702AbgDANYS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 09:24:18 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21120 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732605AbgDANYS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Apr 2020 09:24:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585747457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Stn6oMhGJiyAZPQ6KxLmG6YerXl1pPacj6iIfwszZwM=;
        b=itMbocCiO2vlpp7++8ssmE2BQhWMGFSC8D3XUtS/Sa9qpxfcGgIL/CzjVS7NRhtldLSmdu
        8BE18Jv9Nm9lpu3Ww3gTC85CDDmnLVZsb6ZOJ7DpDBmS/jLcTGl4yqlQ74MMB96JWrpKXK
        Q9dueVeXRKEdqDW3EUM6w9pn5rv6UHo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-T5DcqnexOoKjhdxT4UBwxQ-1; Wed, 01 Apr 2020 09:24:15 -0400
X-MC-Unique: T5DcqnexOoKjhdxT4UBwxQ-1
Received: by mail-wr1-f72.google.com with SMTP id v17so10498543wro.21
        for <kvm@vger.kernel.org>; Wed, 01 Apr 2020 06:24:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Stn6oMhGJiyAZPQ6KxLmG6YerXl1pPacj6iIfwszZwM=;
        b=TUitzII+9SIHh8v66lZPiMgmKB94gIOamHGfm0XUobRx+NkHsoWy4CGuDFppgD8a9g
         g/zME0TqtK3vOEDoiaQtEhjdfdg6A9D3xhq5QpRF7TMmixxOkoHH7KdwPHjBcRx59QFI
         LT64jbC1tBJSlWCNCRlvVUCHXBzxTu+XKeVIm7Q/DFo6oQIDnoQvdLDPkMEw795jBP2Y
         /4JS/NyeBkkcyyFdPJmzOZqF0ceJUDUbJQTvvsrBwiRdjVuyHKG7iY89DfBO5bkPT9dv
         Pt04jNYjepxXC4AmKuzeNE8sQNU0piY8CF0YyPflKnwV2E3lmlpifXezTaYSL0CbHT7p
         lzbw==
X-Gm-Message-State: AGi0PuZH49olfahQ7p5KvFDqhFnviyJIx9as+Q6EMkujFZeO1ppPwWG+
        0jP5zKy8vq+okqwSi6XDCHWOmq+M++UG8FgQKFOo2OvZZtNL/QEz8WZYkzsLphu34hpYyG7m3p3
        NxNgqInZpg46H
X-Received: by 2002:a1c:3b89:: with SMTP id i131mr4294244wma.35.1585747454238;
        Wed, 01 Apr 2020 06:24:14 -0700 (PDT)
X-Google-Smtp-Source: APiQypI3oofehBQ27CNv+6/NoXih1r+7/e25KgRW68ENnQJnWsevdriy2uME3ri2rl/f8Gb/0AHTaQ==
X-Received: by 2002:a1c:3b89:: with SMTP id i131mr4294224wma.35.1585747453980;
        Wed, 01 Apr 2020 06:24:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3dd0:bddb:3deb:b557? ([2001:b07:6468:f312:3dd0:bddb:3deb:b557])
        by smtp.gmail.com with ESMTPSA id a7sm2539196wmm.34.2020.04.01.06.24.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2020 06:24:13 -0700 (PDT)
Subject: Re: [PATCH 2/3] tools/kvm_stat: Add command line switch '-L' to log
 to file
To:     Stefan Raspl <raspl@linux.ibm.com>, kvm@vger.kernel.org
References: <20200331200042.2026-1-raspl@linux.ibm.com>
 <20200331200042.2026-3-raspl@linux.ibm.com>
 <fbc8948f-1d68-62b7-1bfb-08a89ae8e01e@redhat.com>
 <a946ac56-489b-6eb2-d162-80247190c500@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f2e45aad-b7f7-23a0-d04c-3a49212b7cc9@redhat.com>
Date:   Wed, 1 Apr 2020 15:24:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <a946ac56-489b-6eb2-d162-80247190c500@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/04/20 14:59, Stefan Raspl wrote:
> On 2020-03-31 23:02, Paolo Bonzini wrote:
>> On 31/03/20 22:00, Stefan Raspl wrote:
>>> From: Stefan Raspl <raspl@de.ibm.com>
>>>
>>> To integrate with logrotate, we have a signal handler that will re-open
>>> the logfile.
>>> Assuming we have a systemd unit file with
>>>      ExecStart=kvm_stat -dtc -s 10 -L /var/log/kvm_stat.csv
>>>      ExecReload=/bin/kill -HUP $MAINPID
>>> and a logrotate config featuring
>>>      postrotate
>>>         /bin/systemctl restart kvm_stat.service
>>
>> Does reload work too?
> 
> Reload and restart work fine - any specific concerns or areas to look for?

No, I would just put reload in the postrotate script.
>>> +    if opts.log_to_file:
>>> +        f.close()
>>
>> "if f:"?
> 
> I'd argue the former is a lot more telling/easier to read - one of the downsides
> of using extremely short variable names like 'f'.

Fair enough.

Paolo

