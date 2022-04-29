Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D1C515166
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 19:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379439AbiD2RQK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 13:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244469AbiD2RQJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 13:16:09 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38B249C93
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 10:12:50 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 4so11223491ljw.11
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 10:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/dhlPgQ9KVUBw4oSLwyQU5Spph3PG9xofANcDFrXo7E=;
        b=RoLY63DFknlPSUqnhr2f6i4XvnblXUfEvWc48Qfp47ytOxUYDfq5x6v8xwa0da9phh
         lVJw8ZhSf1guh83THMDW91u57kU8MiNVUsKbCrLsKi2tM/+FCLYD9t2keBNidVSJq3+4
         387quv6oqOKeYzv4bWrGPnMxohnfxaQUsEUgh3R1pGB94pmxr8JLb+0xZyuLXiG3RI4O
         z/5Y3yDZl91fkqmFymD1km9dlgUE+6yrGUPmsqHlrYR0pIUjKPQ5ybZvUYS+rGeVr+Xa
         fL+YKJ/ZnMVQQ0pt9pr2Z2cnxjdguNWtHhaJVmhNLmD3rx3DeyrC9blAVTCT+V9xtggH
         J2rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/dhlPgQ9KVUBw4oSLwyQU5Spph3PG9xofANcDFrXo7E=;
        b=AEquqK1rQHAuuLyiQWNA1op+aXfpwCkAnQEXOW8KXAOBI21W8Mw9y3zqP0QTehjc3x
         DcqN+gso4Sv8FBSN6MMzbTdlhsj731lxoeyb4i5oASuM1UZRBMqxeaOD60bflF/MQY24
         tgXWPaZ9W3jO0b7HADZYNC7s6DUwQv7PV1obq8biJ6xwH3IneTRFPqGbJxx/pczUf6Bg
         ufduLcJ1+xBN1SOlZKw51uDON5OJl1A6RYmqgeodMWNJGjvFPZMyiDjweSQOAVS+g4M+
         HlMrkbJ97HKrzbVn2u8QaPPEnV4FYrInIe2H66DBvyhrQyEyG9SlElYd++PZlmTgKW50
         geig==
X-Gm-Message-State: AOAM532KpxVEAT2T5JL28EQTjpvDCUSUbISLWipd1ZbS8hAiURP8Jd8J
        bQSWQQPMu6z+7sTrRyDTFVfOZo1ucmIP7mVMlXYTZM3uNKYFzA==
X-Google-Smtp-Source: ABdhPJxlaAuYZRfV/PHxi4dIOaX1rm6o8uyQRd6aulf9ZN+fwununUyQpbU/3yFq8sQ0jyi4r63E8ckPT8q7dPVlFrg=
X-Received: by 2002:a2e:3c0e:0:b0:24f:25ff:659f with SMTP id
 j14-20020a2e3c0e000000b0024f25ff659fmr140994lja.426.1651252368836; Fri, 29
 Apr 2022 10:12:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220407195908.633003-1-pgonda@google.com> <CAFNjLiXC0AdOw5f8Ovu47D==ex7F0=WN_Ocirymz4xL=mWvC5A@mail.gmail.com>
 <CAMkAt6r-Mc_YN-gVHuCpTj4E1EmcvyYpP9jhtHo5HRHnoNJAdA@mail.gmail.com>
 <CAMkAt6r+OMPWCbV_svUyGWa0qMzjj2UEG29G6P7jb6uH6yko2w@mail.gmail.com>
 <62e9ece1-5d71-f803-3f65-2755160cf1d1@redhat.com> <CAMkAt6q6YLBfo2RceduSXTafckEehawhD4K4hUEuB4ZNqe2kKg@mail.gmail.com>
 <4c0edc90-36a1-4f4c-1923-4b20e7bdbb4c@redhat.com> <CAMkAt6oL5qi7z-eh4z7z8WBhpc=Ow6WtcJA5bDi6-aGMnz135A@mail.gmail.com>
 <CAMkAt6rmDrZfN5DbNOTsKFV57PwEnK2zxgBTCbEPeE206+5v5w@mail.gmail.com>
 <0d282be4-d612-374d-84ba-067994321bab@redhat.com> <CAMkAt6ragq4OmnX+n628Yd5pn51qFv4qV20upGR6tTvyYw3U5A@mail.gmail.com>
 <8a2c5f8c-503c-b4f0-75e7-039533c9852d@redhat.com> <CAMkAt6qAW5zFyTAqX_Az2DT2J3KROPo4u-Ak1sC0J+UTUeFfXA@mail.gmail.com>
 <4afce434-ab25-66d6-76f4-3a987f64e88e@redhat.com>
In-Reply-To: <4afce434-ab25-66d6-76f4-3a987f64e88e@redhat.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 29 Apr 2022 11:12:36 -0600
Message-ID: <CAMkAt6o8u9=H_kjr_xyRO05J=RDFUZRiTc_Bw-FFDKEUaiyp2Q@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: SEV: Mark nested locking of vcpu->lock
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     John Sperbeck <jsperbeck@google.com>,
        kvm list <kvm@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 9:59 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 4/29/22 17:51, Peter Gonda wrote:
> >> No, you don't need any of this.  You can rely on there being only one
> >> depmap, otherwise you wouldn't need the mock releases and acquires at
> >> all.  Also the unlocking order does not matter for deadlocks, only the
> >> locking order does.  You're overdoing it. :)
> >
> > Hmm I'm slightly confused here then. If I take your original suggestion of:
> >
> >          bool acquired = false;
> >          kvm_for_each_vcpu(...) {
> >                  if (acquired)
> >                          mutex_release(&vcpu->mutex.dep_map,
> > _THIS_IP_);  <-- Warning here
> >                  if (mutex_lock_killable_nested(&vcpu->mutex, role)
> >                          goto out_unlock;
> >                  acquired = true;
> >
> > """
> > [ 2810.088982] =====================================
> > [ 2810.093687] WARNING: bad unlock balance detected!
> > [ 2810.098388] 5.17.0-dbg-DEV #5 Tainted: G           O
> > [ 2810.103788] -------------------------------------
>
> Ah even if the contents of the dep_map are the same for all locks, it
> also uses the *pointer* to the dep_map to track (class, subclass) ->
> pointer and checks for a match.
>
> So yeah, prev_cpu is needed.  The unlock ordering OTOH is irrelevant so
> you don't need to visit the xarray backwards.

Sounds good. Instead of doing this prev_vcpu solution we could just
keep the 1st vcpu for source and target. I think this could work since
all the vcpu->mutex.dep_maps do not point to the same string.

Lock:
         bool acquired = false;
         kvm_for_each_vcpu(...) {
                 if (mutex_lock_killable_nested(&vcpu->mutex, role)
                     goto out_unlock;
                acquired = true;
                 if (acquired)
                      mutex_release(&vcpu->mutex, role)
         }

Unlock

         bool acquired = true;
         kvm_for_each_vcpu(...) {
               if (!acquired)
                     mutex_acquire(&vcpu->mutex, role)
               mutex_unlock(&vcpu->mutex);
               acquired = false;
         }

So when locking we release all but the first dep_maps. Then when
unlocking we acquire all but the first dep_maps. Thoughts?

>
> Paolo
>
