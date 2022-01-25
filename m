Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBD249B928
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 17:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1586120AbiAYQri (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 11:47:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:40664 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1585897AbiAYQpb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 11:45:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643129130;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=uIvna9YQgR1Kgio93JKJJObogMUbnRctGnTPlditYbI=;
        b=dfYBFbkWITD2tFD/5jgWOB9Sa1uoT8GcFooA5JZFcr+nBb0uEFdakhKmrhFye3XKspfhgE
        cnoXdwZMDltfCYurD506EcQQmVYx2ftY3ZiE68L8zB6g1NSDFiFgWFSNnpitZmpBpUEQzU
        oPYSvgZi15pj16P9gwXKr90RR4KvtVg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-221-rdmoKYAONIiiqA2ihkiYHQ-1; Tue, 25 Jan 2022 11:45:28 -0500
X-MC-Unique: rdmoKYAONIiiqA2ihkiYHQ-1
Received: by mail-wr1-f70.google.com with SMTP id j26-20020adfb31a000000b001d8e22f75fbso3313597wrd.20
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 08:45:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:user-agent:reply-to:date
         :message-id:mime-version;
        bh=uIvna9YQgR1Kgio93JKJJObogMUbnRctGnTPlditYbI=;
        b=m5latggXbIT+2GLDvVRog6LFkJDD2/Yu3NomSM/qw8vhTkh+cf+49imIFbBEBhA1bs
         L1Ws+RjRj1hCirEpos0g0dqiTct0FQ9BR9gjU2U5nhK2kKSNkbt/HhAuvHuQ6N7i1TgT
         zslz7kB39h5JBDoPPXR7hJgBoqJPMnzbfEcUfbGdd/YAvrGyWe+qK1dGkJbDHsRi/bbc
         oNttLOk4FANnuXkuQf5PIHuPBoBDeLc4Vf+Koa6BWPQOEUhLw9ue63v8zQNi8K90nH2+
         lP2hzPNS2IquAV/bCY5gqXw/pK9C9HZN8D8A++CM7Efnd15vVLjAGhPTr+lnE4DMtiM8
         xfTg==
X-Gm-Message-State: AOAM533Hb+CvFNQqdjzBJdlaYUkjO+8lgEsFTGCwEZ5w98V8dcp86UwU
        NsInJnpi/NEp88+fdKHNcT/ARIkBcos9SbtXFJQkJthJfMoGsff+2N9MazoGTO/1zwTSzzFhqVj
        HrDxT6rLRvmI8Jag4FjlcD4VXgrmamF5x8fPpGS2X1yMNSkSvncXXQkyaN9+TZLYk
X-Received: by 2002:adf:f94c:: with SMTP id q12mr18934742wrr.166.1643129126842;
        Tue, 25 Jan 2022 08:45:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx3ZVAv+oYBiIXH7L5YgJ4zJeY6nIJKIbd905+9lC15R8sNSVTzFZI0XQSjcTxYAbSl2HADaQ==
X-Received: by 2002:adf:f94c:: with SMTP id q12mr18934731wrr.166.1643129126672;
        Tue, 25 Jan 2022 08:45:26 -0800 (PST)
Received: from localhost ([47.61.17.76])
        by smtp.gmail.com with ESMTPSA id n13sm922945wms.8.2022.01.25.08.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 08:45:26 -0800 (PST)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Daniel Berrange <berrange@redhat.com>
Subject: KVM call for agenda for 2022-02-08
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Tue, 25 Jan 2022 17:45:25 +0100
Message-ID: <875yq7rcgq.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi

Please, send any topic that you are interested in covering.

For last week call, we already have one topic.
- get QMP startup early

People asked for Paolo and Daniel to discuss this, so I added them to
this email.

At the end of Monday I will send an email with the agenda or the
cancellation of the call, so hurry up.


By popular demand, a google calendar public entry with it

  https://www.google.com/calendar/embed?src=dG9iMXRqcXAzN3Y4ZXZwNzRoMHE4a3BqcXNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ

(Let me know if you have any problems with the calendar entry.  I just
gave up about getting right at the same time CEST, CET, EDT and DST).

If you need phone number details,  contact me privately.
If you want to be added to the invite, contact me privately.

Thanks, Juan.

