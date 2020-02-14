Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92E1715D5B0
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 11:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729226AbgBNKbI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 05:31:08 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53985 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727965AbgBNKbI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 05:31:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581676267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D60CQsdgOz+ThbjyFMTp5Y/vwHggpDSotXlhS0B+A1Q=;
        b=EreHBU/TUDzKlONXC+zzPFxG/uY0OCOK11b1JE/wIpo4Zx3T2zZS5E2ahwudblNJ7EY5b9
        mf5M0X3LGCyYjUrFFdMUQuwTokq4sDPcSsIvVbTds9FVGGpp/NmcMdw55g2aFr4bulEb9W
        7JHHkHeQ5C7p+q5p9N0eRbUCdw6LAos=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-5ZRKji15Pwq0EtcVhi4kDQ-1; Fri, 14 Feb 2020 05:31:05 -0500
X-MC-Unique: 5ZRKji15Pwq0EtcVhi4kDQ-1
Received: by mail-wr1-f69.google.com with SMTP id d15so3801531wru.1
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 02:31:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D60CQsdgOz+ThbjyFMTp5Y/vwHggpDSotXlhS0B+A1Q=;
        b=WLZ2kyTiki7cBzmr73GVFelLseLugjLzWgZPR/tA4hvTmAnqSr2wsXvpVugjwF71/E
         5oq0xllfgssbqWETIjUk+V2lMq2DjGwNXfqmDbVpz3EpYo4j14sJDzmAA+zj76ijxAgm
         uZuUOTht9JmIWM4HpttAzS1ZdaMa1gANpQ0JsBrwesPmYfxPV9sVEdyscqZlQKjIxC9K
         sY9spG6ZvpZZGeZKGjmXCbbwd9tU2qy4/CPniB7AYkryTpxgbON8R51oXWg3S1arlyfB
         2dAyVgC7GckGIM922Vyq9x0BBS+oXbLYAYwygw+NNAwWtnDEhv12Jbox7P4Te1kmUo5v
         iZtA==
X-Gm-Message-State: APjAAAU6xGf8uflUTGILByIkG30mWF8c4Xq9uprOkEVe8J/zeP4evSWM
        GmFRZOX+SHF+Os6KmzzxkI/1PPr2yW6EF/rVp/FwI6wK32ZahcQreLjLegzWBBcOLaZ5UExGtlE
        +aXd9Pvk0J3bK
X-Received: by 2002:a1c:1f51:: with SMTP id f78mr3934565wmf.60.1581676264029;
        Fri, 14 Feb 2020 02:31:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqwkYQkjH6UR3Z89VMtxB49TfCSXFfMiFz2SLNPntx+MDPjA/Fnz2Z34MZZH7J/gPRN1mFJoYA==
X-Received: by 2002:a1c:1f51:: with SMTP id f78mr3934531wmf.60.1581676263759;
        Fri, 14 Feb 2020 02:31:03 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:59c7:c3ee:2dec:d2b4? ([2001:b07:6468:f312:59c7:c3ee:2dec:d2b4])
        by smtp.gmail.com with ESMTPSA id r1sm6406846wrx.11.2020.02.14.02.31.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 02:31:03 -0800 (PST)
Subject: Re: [PATCH kvm-unit-tests 1/2] arch-run: Allow $QEMU to include
 parameters
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     peter.maydell@linaro.org, alex.bennee@linaro.org,
        lvivier@redhat.com, thuth@redhat.com, david@redhat.com,
        frankja@linux.ibm.com, eric.auger@redhat.com
References: <20200213143300.32141-1-drjones@redhat.com>
 <20200213143300.32141-2-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c14fd5b0-9658-dbe9-a2b2-bf368d57fc7d@redhat.com>
Date:   Fri, 14 Feb 2020 11:31:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200213143300.32141-2-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/02/20 15:32, Andrew Jones wrote:
> +	if [ -n "$QEMU" ]; then
> +		set -- $QEMU
> +		if ! "$1" --help 2>/dev/null | grep -q 'QEMU'; then
> +			echo "\$QEMU environment variable not set to a QEMU binary." >&2
> +			return 2
> +		fi
> +		qemu=$(command -v "$1")
> +		shift
> +		echo "$qemu $@"

I think $* is more appropriate here.  Something like "foo $@ bar" has a
weird effect:

	$ set -x
	$ set a b c

	$ echo "foo $@ bar"
	+ echo 'foo a' b 'c bar'
	foo a b c bar

	$ echo "foo $* bar"
	+ echo 'foo a b c bar'
	foo a b c bar

Otherwise, this is a good idea.

Thanks,

Paolo

> +		return
> +	fi
> +

