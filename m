Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD8F286646
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 19:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgJGRx4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 13:53:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39049 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727085AbgJGRx4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Oct 2020 13:53:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602093234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wkv1LonlQeT5UBNJLTQ7QmWoIbUunt1WKxKHWvxBZHU=;
        b=ax1E0/OP5jHlTXUtVZzgO8I3Dt4H7ICPwVoCswBtlTzMDG8wg2ly7Zg3dU+iF7crAy4p04
        1j3zKZihJvlZyW02DzOBiQFke5UNBbc1amRioVRebWnqezbuWG2ck/64uzv4DGiB9csRGO
        r1Bpb6e1lXZ242o87vp+GnO8bkt7hDw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365--xSZtlsYMmeU9DIYKmA17w-1; Wed, 07 Oct 2020 13:53:53 -0400
X-MC-Unique: -xSZtlsYMmeU9DIYKmA17w-1
Received: by mail-wm1-f69.google.com with SMTP id 13so1262576wmf.0
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 10:53:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Wkv1LonlQeT5UBNJLTQ7QmWoIbUunt1WKxKHWvxBZHU=;
        b=C0mHizChB83qcs4lUo9LchbKb7W64bpy4JCSOZlix9T50Zmp719kdr4+iPAR7d7mWQ
         dShkSLOrDK7ezKKPTPqVHZ1uDva6AVs988+pmOFGIm61aToxiL5Rsd7+miapCB8pOAMA
         JSqh7Y7YEqCT3QokhE48RGpRIxYvFKjZ8YSb46jxvNbkBchCmLN5n/a7WGNi4yeKPJ/G
         tWwmQSh5vtuKavreA+SOex4NK9PicDzTP4nrpyT0XqKr4gAlqrzjyY9BujzcJgvW1HvH
         1iwqAQ61zjCwHeY8Ra+IpkGzpf2DyzFeXwc55gAbId6i+QsFkaLHfcnTzYMBEDsZJbY4
         AwnA==
X-Gm-Message-State: AOAM531sNfK0drWdK+kTWqW9scRRTlEiuXUMdL6JSYegtH2IrC+mB3Tu
        Hi3CDmHFS4XhgTIIuaqZisdzZDQW666QgSeQRVoLnAbzjUBnCYYOQQW8DGOfjDCRNccEhO0VG1f
        e1b9klMX3c+tF
X-Received: by 2002:a1c:bb84:: with SMTP id l126mr4806475wmf.159.1602093231882;
        Wed, 07 Oct 2020 10:53:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx66R/eljpuRHcwEkISzskFEnh6eFZvXspkuojvwqTEM48rNfW48Y3jx1D6geUNIh8ejoUSpQ==
X-Received: by 2002:a1c:bb84:: with SMTP id l126mr4806458wmf.159.1602093231631;
        Wed, 07 Oct 2020 10:53:51 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d2f4:5943:190c:39ff? ([2001:b07:6468:f312:d2f4:5943:190c:39ff])
        by smtp.gmail.com with ESMTPSA id u81sm3439550wmg.43.2020.10.07.10.53.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 10:53:50 -0700 (PDT)
Subject: Re: [PATCH 18/22] kvm: mmu: Support disabling dirty logging for the
 tdp MMU
To:     Ben Gardon <bgardon@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-19-bgardon@google.com>
 <44822999-f5dc-6116-db12-a41f5bd80dd8@redhat.com>
 <CANgfPd_dQ19sZz2wzSfz7-RzdbQrfP6cYJLpSYbyNyQW6Uf09Q@mail.gmail.com>
 <5dc72eec-a4bd-f31a-f439-cdf8c5b48c05@redhat.com>
 <CANgfPd8Nzi2Cb3cvh5nFoaXTPbfm7Y77e4iM6-zOp5Qa3wNJBw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0dd49e95-181f-e6eb-5e3f-ed32d20c2196@redhat.com>
Date:   Wed, 7 Oct 2020 19:53:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CANgfPd8Nzi2Cb3cvh5nFoaXTPbfm7Y77e4iM6-zOp5Qa3wNJBw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/10/20 19:28, Ben Gardon wrote:
>> No, that would be just another way to write the same thing.  That said,
>> making the iteration API more complicated also has disadvantages because
>> if get a Cartesian explosion of changes.
> I wouldn't be too worried about that. The only things I ever found
> worth making an iterator case for were:
> Every SPTE
> Every present SPTE
> Every present leaf SPTE

* (vcpu, root) * (all levels, large only)

We only need a small subset of these, but the naming would be more
complex at least.

Paolo

