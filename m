Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E3F6F5F62
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 21:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjECTpv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 15:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjECTpr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 15:45:47 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2987ED9
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 12:45:45 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f1763ee8f8so37769705e9.1
        for <kvm@vger.kernel.org>; Wed, 03 May 2023 12:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683143144; x=1685735144;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZN9SCBcx2ViqEMGRfFXiNyjtqYM584QAIWBPcow4amM=;
        b=KeUbIYrY5kiOGnFrJaEPoGxzw1X/z5w0adl5bkHFYIzakq2Q81hc4g46g03LjUs80p
         Bgv7eGdqaJ9RKZayp5zUx4jwVGtLGayekSa1bY53isRcdLnjMrzfiOhBaFpqv8TmxWzk
         BnePlcwISdbS+maPK79/HxvtP+GFYofHiQH9VKt1vq8IfHd97t+ZNzqTRgsnUXiLgu5i
         tBQ51+Wx1PZKfSkwHvVMaIN7HEaPtRq/TUXlUOz/y2zKjtgePoazkRM5RsOYd4Ftuzpa
         4jIkDs3ao5AvqIW0QSqrPhzcGJxEeDakJ70oVTlpnokukvIlXp9TbPwlEfO+ogNwMBpp
         NVJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683143144; x=1685735144;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZN9SCBcx2ViqEMGRfFXiNyjtqYM584QAIWBPcow4amM=;
        b=Bp1+OSlDmjPKaYYGKlkDhXjib0BH2663Y8JhPLS6KEmGL22hFo5OYmbkjXL1LsIORw
         z2c229H56zg/yON4HWJ68iUPzzIiW67UjukfYTtaevioUgjlj2MWo42lEfp941waFtiF
         aK6L7BzVmTU/OgHTNhD8R3sqlWiUO6cfLb10TLqV0a/kvzRcre1G90sK3WnEaBD0CFAH
         vIVUsvFFSnbh7t08ax0o/FSby6rs0VjACqeQILpV32jclX3MDigzYq/+kowaRxTAScY7
         tmE9Dj3PmvoyRaEBgDsCQkzgn92hV3x41MVsvrLLegWmWmDkF06g/pSameLYjYemjmKR
         DVJw==
X-Gm-Message-State: AC+VfDzOI8nZbUllnRb10DcBttMxqYUBhiGbfSSH0ets9sbnyq3zBecA
        OHJJOUVqE3axs5SrWn9GApYP8GGYOJRoR0n3Htk+CQ==
X-Google-Smtp-Source: ACHHUZ5egV4i+OwXEdYNDPLGVEGzVG5Seqj9/+jaFq19JZxHvehwHkYKSqZNoYYnKIScfvjfO/pTJpIHUfwq+yQSMw4=
X-Received: by 2002:a7b:c408:0:b0:3f1:73ce:e1dd with SMTP id
 k8-20020a7bc408000000b003f173cee1ddmr15362477wmi.10.1683143143896; Wed, 03
 May 2023 12:45:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <ZEBHTw3+DcAnPc37@x1n>
 <CAJHvVchBqQ8iVHgF9cVZDusMKQM2AjtNx2z=i9ZHP2BosN4tBg@mail.gmail.com>
 <ZEBXi5tZZNxA+jRs@x1n> <CAF7b7mo68VLNp=QynfT7QKgdq=d1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>
 <ZEGuogfbtxPNUq7t@x1n> <46DD705B-3A3F-438E-A5B1-929C1E43D11F@gmail.com>
 <CAF7b7mo78e2YPHU5YrhzuORdpGXCVRxXr6kSyMa+L+guW8jKGw@mail.gmail.com>
 <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com> <CAF7b7mr-_U6vU1iOwukdmOoaT0G1ttyxD62cv=vebnQeXL3R0w@mail.gmail.com>
 <ZErahL/7DKimG+46@x1n>
In-Reply-To: <ZErahL/7DKimG+46@x1n>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Wed, 3 May 2023 12:45:07 -0700
Message-ID: <CAF7b7mqaxk6w90+9+5UkEAE13vDTmBMmCO_ZdAEo6pD8_--fZA@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
To:     Peter Xu <peterx@redhat.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
        oliver.upton@linux.dev, Sean Christopherson <seanjc@google.com>,
        James Houghton <jthoughton@google.com>, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com,
        kvm <kvm@vger.kernel.org>, kvmarm@lists.linux.dev
Content-Type: multipart/mixed; boundary="00000000000033800305facf4d86"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--00000000000033800305facf4d86
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 27, 2023 at 1:26=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> Thanks (for doing this test, and also to Nadav for all his inputs), and
> sorry for a late response.

No need to apologize: anyways, I've got you comfortably beat on being
late at this point :)

> These numbers caught my eye, and I'm very curious why even 2 vcpus can
> scale that bad.
>
> I gave it a shot on a test machine and I got something slightly different=
:
>
>   Intel(R) Xeon(R) CPU E5-2630 v4 @ 2.20GHz (20 cores, 40 threads)
>   $ ./demand_paging_test -b 512M -u MINOR -s shmem -v N
>   |-------+----------+--------|
>   | n_thr | per-vcpu | total  |
>   |-------+----------+--------|
>   |     1 | 39.5K    | 39.5K  |
>   |     2 | 33.8K    | 67.6K  |
>   |     4 | 31.8K    | 127.2K |
>   |     8 | 30.8K    | 246.1K |
>   |    16 | 21.9K    | 351.0K |
>   |-------+----------+--------|
>
> I used larger ram due to less cores.  I didn't try 32+ vcpus to make sure=
 I
> don't have two threads content on a core/thread already since I only got =
40
> hardware threads there, but still we can compare with your lower half.
>
> When I was testing I noticed bad numbers and another bug on not using
> NSEC_PER_SEC properly, so I did this before the test:
>
> https://lore.kernel.org/all/20230427201112.2164776-1-peterx@redhat.com/
>
> I think it means it still doesn't scale that good, however not so bad
> either - no obvious 1/2 drop on using 2vcpus.  There're still a bunch of
> paths triggered in the test so I also don't expect it to fully scale
> linearly.  From my numbers I just didn't see as drastic as yours. I'm not
> sure whether it's simply broken test number, parameter differences
> (e.g. you used 64M only per-vcpu), or hardware differences.

Hmm, I suspect we're dealing with  hardware differences here. I
rebased my changes onto those two patches you sent up, taking care not
to clobber them, but even with the repro command you provided my
results look very different than yours (at least on 1-4 vcpus) on the
machine I've been testing on (4x AMD EPYC 7B13 64-Core, 2.2GHz).

(n=3D20)
n_thr      per_vcpu       total
1            154K              154K
2             92k                184K
4             71K                285K
8             36K                291K
16           19K                310K

Out of interested I tested on another machine (Intel(R) Xeon(R)
Platinum 8273CL CPU @ 2.20GHz) as well, and results are a bit
different again

(n=3D20)
n_thr      per_vcpu       total
1            115K              115K
2             103k              206K
4             65K                262K
8             39K                319K
16           19K                398K

It is interesting how all three sets of numbers start off different
but seem to converge around 16 vCPUs. I did check to make sure the
memory fault exits sped things up in all cases, and that at least
stays true.

By the way, I've got a little helper script that I've been using to
run/average the selftest results (which can vary quite a bit). I've
attached it below- hopefully it doesn't bounce from the mailing list.
Just for reference, the invocation to test the command you provided is

> python dp_runner.py --num_runs 20 --max_cores 16 --percpu_mem 512M

--00000000000033800305facf4d86
Content-Type: text/x-python; charset="US-ASCII"; name="dp_runner.py"
Content-Disposition: attachment; filename="dp_runner.py"
Content-Transfer-Encoding: base64
Content-ID: <f_lh83syqb0>
X-Attachment-Id: f_lh83syqb0

aW1wb3J0IHN1YnByb2Nlc3MKaW1wb3J0IGFyZ3BhcnNlCmltcG9ydCByZQoKZGVmIGdldF9jb21t
YW5kKHBlcmNwdV9tZW0sIGNvcmVzLCBzaW5nbGVfdWZmZCwgdXNlX21lbWZhdWx0cywgb3Zlcmxh
cF92Y3B1cyk6CiAgIGlmIG92ZXJsYXBfdmNwdXMgYW5kIG5vdCBzaW5nbGVfdWZmZDoKICAgICAg
IHJhaXNlIFJ1bnRpbWVFcnJvcigiT3ZlcmxhcHBpbmcgdmNwdXMgYnV0IG5vdCB1c2luZyBzaW5n
bGUgdWZmZCwgdmVyeSBzdHJhbmdlIikKICAgcmV0dXJuICIuL2RlbWFuZF9wYWdpbmdfdGVzdCAt
cyBzaG1lbSAtdSBNSU5PUiAiIFwKICAgICAgICArICIgLWIgIiArIHBlcmNwdV9tZW0gXAogICAg
ICAgICsgKCIgLWEgIiBpZiBzaW5nbGVfdWZmZCBvciBvdmVybGFwX3ZjcHVzIGVsc2UgIiIpIFwK
ICAgICAgICArICgiIC1vICIgaWYgb3ZlcmxhcF92Y3B1cyBlbHNlICIiKSBcCiAgICAgICAgKyAi
IC12ICIgKyBzdHIoY29yZXMpIFwKICAgICAgICArICIgLXIgIiArIChzdHIoY29yZXMpIGlmIHNp
bmdsZV91ZmZkIG9yIG92ZXJsYXBfdmNwdXMgZWxzZSAiMSIpIFwKICAgICAgICArICgiIC13IiBp
ZiB1c2VfbWVtZmF1bHRzIGVsc2UgIiIpIFwKICAgICAgICArICI7IGV4aXQgMCIKCmRlZiBydW5f
Y29tbWFuZChjbWQpOgoKICAgIG91dHB1dCA9IHN1YnByb2Nlc3MuY2hlY2tfb3V0cHV0KGNtZCwg
c2hlbGw9VHJ1ZSkKICAgIHZfcGFnaW5nX3JhdGVfcmUgPSByIlBlci12Y3B1IGRlbWFuZCBwYWdp
bmcgcmF0ZTpccyooLiopIHBncy9zZWMiCiAgICB0X3BhZ2luZ19yYXRlX3JlID0gciJPdmVyYWxs
IGRlbWFuZCBwYWdpbmcgcmF0ZTpccyooLiopIHBncy9zZWMiCiAgICB2X21hdGNoID0gcmUuc2Vh
cmNoKHZfcGFnaW5nX3JhdGVfcmUsIG91dHB1dCwgcmUuTVVMVElMSU5FKQogICAgdF9tYXRjaCA9
IHJlLnNlYXJjaCh0X3BhZ2luZ19yYXRlX3JlLCBvdXRwdXQsIHJlLk1VTFRJTElORSkKICAgIHJl
dHVybiBmbG9hdCh2X21hdGNoLmdyb3VwKDEpKSwgZmxvYXQodF9tYXRjaC5ncm91cCgxKSkKCmlm
IF9fbmFtZV9fID09ICJfX21haW5fXyI6CiAgICBhcCA9IGFyZ3BhcnNlLkFyZ3VtZW50UGFyc2Vy
KCkKICAgIGFwLmFkZF9hcmd1bWVudCgiLS1udW1fcnVucyIsIHR5cGU9aW50LCBkZXN0PSdudW1f
cnVucycsIHJlcXVpcmVkPVRydWUpCiAgICBhcC5hZGRfYXJndW1lbnQoIi0tbWF4X2NvcmVzIiwg
dHlwZT1pbnQsIGRlc3Q9J21heF9jb3JlcycsIHJlcXVpcmVkPVRydWUpCiAgICBhcC5hZGRfYXJn
dW1lbnQoIi0tcGVyY3B1X21lbSIsIHR5cGU9c3RyLCBkZXN0PSdwZXJjcHVfbWVtJywgcmVxdWly
ZWQ9VHJ1ZSkKICAgIGFwLmFkZF9hcmd1bWVudCgiLS1vbmV1ZmZkIiwgdHlwZT1ib29sLCBkZXN0
PSdvbmV1ZmZkJykKICAgIGFwLmFkZF9hcmd1bWVudCgiLS1vdmVybGFwIiwgdHlwZT1ib29sLCBk
ZXN0PSdvdmVybGFwJykKICAgIGFwLmFkZF9hcmd1bWVudCgiLS1tZW1mYXVsdHMiLCB0eXBlPWJv
b2wsIGRlc3Q9J21lbWZhdWx0cycpCgogICAgYXJncyA9IGFwLnBhcnNlX2FyZ3MoKQoKICAgIHBy
aW50KCJUZXN0aW5nIGNvbmZpZ3VyYXRpb246ICIgKyBzdHIoYXJncykpCiAgICBwcmludCgiIikK
CiAgICBjb3JlcyA9IDEKICAgIGNvcmVzX2FyciA9IFtdCiAgICByZXN1bHRzID0gW10KICAgIHdo
aWxlIGNvcmVzIDw9IGFyZ3MubWF4X2NvcmVzOgogICAgICAgIGNtZCA9IGdldF9jb21tYW5kKGFy
Z3MucGVyY3B1X21lbSwgY29yZXMsIGFyZ3Mub25ldWZmZCwgYXJncy5tZW1mYXVsdHMsIGFyZ3Mu
b3ZlcmxhcCkKICAgICAgICBpZiBjb3JlcyA9PSAxIG9yIGNvcmVzID09IDI6CiAgICAgICAgICAg
IHByaW50KCJjbWQgPSAiICsgY21kKQoKICAgICAgICBwcmludCgiVGVzdGluZyBjb3JlcyA9ICIg
KyBzdHIoY29yZXMpKQogICAgICAgIGZ1bGxfcmVzdWx0cyA9IFtydW5fY29tbWFuZChjbWQpIGZv
ciBfIGluIHJhbmdlKGFyZ3MubnVtX3J1bnMpXQogICAgICAgIHZfcmF0ZXMgPSBbZlswXSBmb3Ig
ZiBpbiBmdWxsX3Jlc3VsdHNdCiAgICAgICAgdF9yYXRlcyA9IFtmWzFdIGZvciBmIGluIGZ1bGxf
cmVzdWx0c10KCiAgICAgICAgZGVmIHByaW50X3JhdGVzKHRhZywgcmF0ZXMpOgogICAgICAgICAg
ICBhdmVyYWdlID0gc3VtKHJhdGVzKSAvIGxlbihyYXRlcykKICAgICAgICAgICAgcHJpbnQodGFn
ICsgIjpcdFx0IiArIHN0cihpbnQoYXZlcmFnZSAvIDEwKSAvIDEwMCkpCgogICAgICAgIHByaW50
X3JhdGVzKCJWY3B1IGRlbWFuZCBwYWdpbmcgcmF0ZSIsIHZfcmF0ZXMpCiAgICAgICAgcHJpbnRf
cmF0ZXMoIlRvdGFsIGRlbWFuZCBwYWdpbmcgcmF0ZSIsIHRfcmF0ZXMpCgogICAgICAgIGNvcmVz
X2Fyci5hcHBlbmQoY29yZXMpCiAgICAgICAgcmVzdWx0cy5hcHBlbmQoKGNvcmVzLCB2X3JhdGVz
LCB0X3JhdGVzKSkKICAgICAgICBjb3JlcyAqPSAyCgogICAgZm9yIGMsIHZfcmF0ZXMsIHRfcmF0
ZXMgaW4gcmVzdWx0czoKICAgICAgICBwcmludCgiRnVsbCByZXN1bHRzIG9uIGNvcmUgIiArIHN0
cihjKSArICIgOlxuIiArIHN0cih2X3JhdGVzKSArICJcbiIgKyBzdHIodF9yYXRlcykpCgo=
--00000000000033800305facf4d86--
