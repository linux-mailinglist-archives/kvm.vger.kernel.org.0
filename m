Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D4F39461D
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 18:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235848AbhE1Q6g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 May 2021 12:58:36 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:35194 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236198AbhE1Q6b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 May 2021 12:58:31 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3993E218B3;
        Fri, 28 May 2021 16:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1622220945; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TFHyn06x92pSJnqljPdfsH/lyyqMtzPyPJZV7LtKFPQ=;
        b=AL93GJKvwnA1U8pUcBQzZP8PuTSgNgos1GXvblt4gcjmzdffACxLG8VzRDvEo1ukLQrZPa
        IFqGkWr6jcZ0GMeeL3UY8CV6z34csOixZQM0YpBJWYTgAtC6+9MNFbYdFIApa8ko37TIiS
        EU6JLBZsPAShVyPJf5D0SEAxPXtdJa8=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 3C4AF118DD;
        Fri, 28 May 2021 16:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1622220944; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TFHyn06x92pSJnqljPdfsH/lyyqMtzPyPJZV7LtKFPQ=;
        b=a4zBuVQ5S8t4WOzh8YWZl/3lQN12H0BMLkhKWiS/BFwYKGwGxK6taa4w9AvOkbIHblxm9m
        5FnJ8z5ckES01r0AU66B9LdQHO706/HgBoQ3IQVNP11MSPi0zgeFdW0iTnp5OyngR4vXBu
        nmcilxEUnwCAPFL+IBtxgr7z3bYK6gU=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id kag5DJAgsWDOPgAALh3uQQ
        (envelope-from <dfaggioli@suse.com>); Fri, 28 May 2021 16:55:44 +0000
Message-ID: <d7dc2464a8aa3caf64f955fe6c9df0cb8fe3b746.camel@suse.com>
Subject: Re: [PATCH] Move VMEnter and VMExit tracepoints closer to the
 actual event
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Stefano De Venuto <stefano.devenuto99@gmail.com>
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, rostedt@goodmis.org,
        y.karadz@gmail.com
Date:   Fri, 28 May 2021 18:55:43 +0200
In-Reply-To: <ab44e5b1-4448-d6c8-6cda-5e41866f69f1@redhat.com>
References: <20210519182303.2790-1-stefano.devenuto99@gmail.com>
         <YKaBEn6oUXaVAb0K@google.com>
         <ab44e5b1-4448-d6c8-6cda-5e41866f69f1@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-JNouEV/PXAMFUgcK4W2M"
User-Agent: Evolution 3.40.1 (by Flathub.org) 
MIME-Version: 1.0
Authentication-Results: imap.suse.de;
        none
X-Spam-Level: 
X-Spam-Score: -0.60
X-Spamd-Result: default: False [-0.60 / 100.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.20)[multipart/signed,text/plain];
         DKIM_SIGNED(0.00)[suse.com:s=susede1];
         RCPT_COUNT_TWELVE(0.00)[12];
         SIGNED_PGP(-2.00)[];
         FREEMAIL_TO(0.00)[redhat.com,google.com,gmail.com];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+,1:+,2:~];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[];
         SUSPICIOUS_RECIPS(1.50)[];
         FREEMAIL_CC(0.00)[vger.kernel.org,redhat.com,tencent.com,google.com,kernel.org,zytor.com,goodmis.org,gmail.com]
X-Spam-Flag: NO
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-JNouEV/PXAMFUgcK4W2M
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-05-20 at 18:18 +0200, Paolo Bonzini wrote:
> On 20/05/21 17:32, Sean Christopherson wrote:
> > On VMX, I think the tracepoint can be moved below the VMWRITEs
> > without much
> > contention (though doing so is likely a nop), but moving it below
> > kvm_load_guest_xsave_state() requires a bit more discussion.
>=20
> Indeed; as a rule of thumb, the tracepoint on SVM could match the=20
> clgi/stgi region, and on VMX it could be placed in a similar location.
>=20
So, we played a little bit with this and, as envisioned, we can confirm
that moving the tracepoint outside of the xsave handling calls results
in the actual trace looking pretty much the same as it does right now.

Still, I think we should go for it, and we're planning to send a v2 of
this patch that does exactly that. In fact, I think it's still better
to have the tracepoint closer to the actual instruction (provided they
don't end up too close, as we were saying in this thread).

For instance, despite the sequence of events being the same in the
"output", the timestamp of the event that we see in the trace would be
more accurate (although, we're of course talking about very small
differences) and, more importantly, we reduce the chances that more
events creeps in, if tracepoints for them are added in the code between
where the trace_kvm_enter/exit() code are now and where we'd like to
move them.

So, Paolo, just to be sure, when you said "the tracepoint on SVM could
match the clgi/stgi region", did you mean they should be outside of
this region (i.e., trace_kvm_enter() just before clgi() and
trace_kvm_exit() after stgi())? Or vice versa? :-)

Thanks and Regards

Dario
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-JNouEV/PXAMFUgcK4W2M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmCxII8ACgkQFkJ4iaW4
c+7z9BAAjkfVactXWKL+SnXmPSstEcjdkAQL+6VF2MA2DNTmvIjrec/x9o8Mjatz
M90zfqxq+TuvF7BY6XvYmEoy2Ris4vNh4YFtecWKudI5QsJh6d0Snr+v5s3rHeAS
JXAEfXnVKkvYrxSNpcW28qZlcbbAx3KTy0CjlySBmba99wq4JekJ5pQEmvxNeA9y
eWTuHiUyS3S7dlf5xGydLVjF6TjbuuCuQ7AMb2aNMlALHkDfuZmohOvEWrUZP6dm
injNK0G9HDETwqTwKIVw6HWbkAKp8d5plPAvRmI6PwDfrZKfS++yxl/KSbloJhrt
7R41Shxu5RzwER86F61EeRwHlr5JXSCJq8D27auWZ29Qo6c4sdfu9Qw43zz4Vmy/
lDyJbOnG6lE6XuPbxVe/ak/VAZlMGEVoQa/4FR62716JgoradjfiBGGqqy3YFzkJ
z2ikf4y7eFCLUe487KGxhdOQqBoY4eHmFGMe8pFZSyanVXCHblcryvh3/ZiNNlRe
9YbQ0L5z+XJX2zUFbSfkcdUZmpMyy2toTeishktXAxuiaTOenACDMWFvr+pGpL/A
AkgKQBzJBKb+AAFH60jddDbg4z17A5STr9Qfoj+DbsCxiyTNhk83msh9CMFU/dz4
8uk/Gzkq+vxWX3BuJ32H1R1hMjczxG0DaT7OgSFHJLZ+FD/jWXA=
=rz+r
-----END PGP SIGNATURE-----

--=-JNouEV/PXAMFUgcK4W2M--

