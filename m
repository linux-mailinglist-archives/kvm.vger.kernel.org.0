Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 629B4605A2
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 13:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbfGEL6o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 07:58:44 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44452 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727261AbfGEL6n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 07:58:43 -0400
Received: by mail-wr1-f65.google.com with SMTP id b2so8428737wrx.11
        for <kvm@vger.kernel.org>; Fri, 05 Jul 2019 04:58:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sSP7etyox4aCXSbmmXqtAa/Z3YWMIdovt5LD60sC6pk=;
        b=eYqPN5Ea2OFejdShDpUQb6LiAuFsxK3nC1KN0HFQxuYnMTmM2EhRotmlbnKpKV5hvW
         c94W/hsiP9a8z2mxz+lsjleUD6VVEO8ZMkSZt4MF7paZBA73W42d+Gi5gfcJN73anAFq
         FOyASGiXRA0Odh/eQ0DtTNqyWyUwIR8a/2Bm4Fw2HFSas4dXI89wn8HCkHaBB5+cWKM9
         EAoXxrj16pobKILp6Z/QYxu7fFifUJmiMR5ZOnXP3J6tk4eM86bYyRRK9Kv1cO3n7fw0
         KvV/Xx9EMRdtV9WJMcNTGwso70ly2J2Rng5a/+6LQBLYp02wk+oARPtk+WAGw7mR40yR
         Q+Ew==
X-Gm-Message-State: APjAAAXdu2sJTx8BZRoCSg17jDzLe4DdrkoXjgH1LEsD/dsnjOykHDP1
        FFzSNYcdO2o8UfBWfN1DfKHeng==
X-Google-Smtp-Source: APXvYqxyhtfq5EKToa35JCnlw7GpbLScGtHw2moWsKyk282RbMxrzF+Y3/E6uFyVJoI/9J7VWPQvkg==
X-Received: by 2002:a5d:5450:: with SMTP id w16mr4049000wrv.128.1562327921117;
        Fri, 05 Jul 2019 04:58:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e943:5a4e:e068:244a? ([2001:b07:6468:f312:e943:5a4e:e068:244a])
        by smtp.gmail.com with ESMTPSA id 72sm8576148wrk.22.2019.07.05.04.58.39
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 04:58:40 -0700 (PDT)
Subject: Re: [PATCH 0/2] scsi: add support for request batching
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org, stefanha@redhat.com
References: <20190530112811.3066-1-pbonzini@redhat.com>
 <746ad64a-4047-1597-a0d4-f14f3529cc19@redhat.com>
 <yq1lfxnk8ar.fsf@oracle.com>
 <48c7d581-6ec8-260a-b4ba-217aef516305@redhat.com>
 <80dd68bf-a544-25ec-568f-cee1cf0c8cfd@suse.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6c2cf159-9ba2-da39-6e1c-95dea7e111ba@redhat.com>
Date:   Fri, 5 Jul 2019 13:58:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <80dd68bf-a544-25ec-568f-cee1cf0c8cfd@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/07/19 09:13, Hannes Reinecke wrote:
> On 6/27/19 10:17 AM, Paolo Bonzini wrote:
>> On 27/06/19 05:37, Martin K. Petersen wrote:
>>>> Ping?  Are there any more objections?
>>> It's a core change so we'll need some more reviews. I suggest you
>>> resubmit.
>> Resubmit exactly the same patches?
>> Where is the ->commit_rqs() callback invoked?
> I don't seem to be able to find it...

Stefan answered, and the series now has three reviews!  It may be late
for 5.3 but I hope this can go in soon.

Thanks,

Paolo
