Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E642E90D3
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 08:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbhADHRR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 02:17:17 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3380 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725921AbhADHRQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Jan 2021 02:17:16 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10473EwP011904;
        Mon, 4 Jan 2021 02:16:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 message-id : reply-to : references : mime-version : content-type :
 in-reply-to : subject; s=pp1;
 bh=UPh3XwP1kEMkh2iasn5Ypwtn/eLjqUiyXcFMlS70N3c=;
 b=BcSWJXD+9OOxcrLXXfBOGVp74TrlDBtqF+u5KkGPmJBzks4+GXV66PAEUFYHc0r2Pj0X
 1bxMOHpwpecMeGTLYtJt7KVyRueL3cbn3rFmdJDf6U/etLHyk6LqlsCwCEJ0iVfmoF7S
 teuxn6KR8oEE/8/cQEDVHxT4yoW15tBLETXeiYw49V8vlR+CveuT+MCxM3uDkYXHHr6+
 7kvy2EWO5/MxKTiwS0WV/hs8I2yD4Mf7txuL9eM8tMTzYpaHRby2xyp/207Z0QNBLeFz
 wmDHgxkwcUSSPNaX7IkyTfhuzixdEjtggy2rDL3PObtbP5QPdPw9MGcZcPfC7oaj8YST Rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35uva8jphb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 02:16:03 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10473wDK014152;
        Mon, 4 Jan 2021 02:16:03 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35uva8jpgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 02:16:03 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 1047Dnap002886;
        Mon, 4 Jan 2021 07:16:01 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 35tg3h9m4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 07:16:01 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1047Ftfd24772880
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Jan 2021 07:15:55 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39AFFA4057;
        Mon,  4 Jan 2021 07:15:58 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA254A4055;
        Mon,  4 Jan 2021 07:15:53 +0000 (GMT)
Received: from ram-ibm-com.ibm.com (unknown [9.163.29.145])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  4 Jan 2021 07:15:53 +0000 (GMT)
Date:   Sun, 3 Jan 2021 23:15:50 -0800
From:   Ram Pai <linuxram@us.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Greg Kurz <groug@kaod.org>, pair@us.ibm.com, brijesh.singh@amd.com,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        qemu-devel@nongnu.org, frankja@linux.ibm.com, david@redhat.com,
        mdroth@linux.vnet.ibm.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, David Gibson <david@gibson.dropbear.id.au>,
        thuth@redhat.com, Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        dgilbert@redhat.com, qemu-s390x@nongnu.org, rth@twiddle.net,
        berrange@redhat.com, Marcelo Tosatti <mtosatti@redhat.com>,
        qemu-ppc@nongnu.org, pbonzini@redhat.com
Message-ID: <20210104071550.GA22585@ram-ibm-com.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
 <20201204054415.579042-12-david@gibson.dropbear.id.au>
 <20201214182240.2abd85eb.cohuck@redhat.com>
 <20201217054736.GH310465@yekko.fritz.box>
 <20201217123842.51063918.cohuck@redhat.com>
 <20201217151530.54431f0e@bahia.lan>
 <20201218124111.4957eb50.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201218124111.4957eb50.cohuck@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
Subject: Re:  Re: [for-6.0 v5 11/13] spapr: PEF: prevent migration
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-04_04:2020-12-31,2021-01-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 priorityscore=1501 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101040047
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 18, 2020 at 12:41:11PM +0100, Cornelia Huck wrote:
> On Thu, 17 Dec 2020 15:15:30 +0100
> Greg Kurz <groug@kaod.org> wrote:
> 
> > On Thu, 17 Dec 2020 12:38:42 +0100
> > Cornelia Huck <cohuck@redhat.com> wrote:
> > 
> > > On Thu, 17 Dec 2020 16:47:36 +1100
> > > David Gibson <david@gibson.dropbear.id.au> wrote:
> > >   
> > > > On Mon, Dec 14, 2020 at 06:22:40PM +0100, Cornelia Huck wrote:  
> > > > > On Fri,  4 Dec 2020 16:44:13 +1100
> > > > > David Gibson <david@gibson.dropbear.id.au> wrote:
> > > > >     
> > > > > > We haven't yet implemented the fairly involved handshaking that will be
> > > > > > needed to migrate PEF protected guests.  For now, just use a migration
> > > > > > blocker so we get a meaningful error if someone attempts this (this is the
> > > > > > same approach used by AMD SEV).
> > > > > > 
> > > > > > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > > > > > Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > > > > > ---
> > > > > >  hw/ppc/pef.c | 9 +++++++++
> > > > > >  1 file changed, 9 insertions(+)
> > > > > > 
> > > > > > diff --git a/hw/ppc/pef.c b/hw/ppc/pef.c
> > > > > > index 3ae3059cfe..edc3e744ba 100644
> > > > > > --- a/hw/ppc/pef.c
> > > > > > +++ b/hw/ppc/pef.c
> > > > > > @@ -38,7 +38,11 @@ struct PefGuestState {
> > > > > >  };
> > > > > >  
> > > > > >  #ifdef CONFIG_KVM
> > > > > > +static Error *pef_mig_blocker;
> > > > > > +
> > > > > >  static int kvmppc_svm_init(Error **errp)    
> > > > > 
> > > > > This looks weird?    
> > > > 
> > > > Oops.  Not sure how that made it past even my rudimentary compile
> > > > testing.
> > > >   
> > > > > > +
> > > > > > +int kvmppc_svm_init(SecurableGuestMemory *sgm, Error **errp)
> > > > > >  {
> > > > > >      if (!kvm_check_extension(kvm_state, KVM_CAP_PPC_SECURABLE_GUEST)) {
> > > > > >          error_setg(errp,
> > > > > > @@ -54,6 +58,11 @@ static int kvmppc_svm_init(Error **errp)
> > > > > >          }
> > > > > >      }
> > > > > >  
> > > > > > +    /* add migration blocker */
> > > > > > +    error_setg(&pef_mig_blocker, "PEF: Migration is not implemented");
> > > > > > +    /* NB: This can fail if --only-migratable is used */
> > > > > > +    migrate_add_blocker(pef_mig_blocker, &error_fatal);    
> > > > > 
> > > > > Just so that I understand: is PEF something that is enabled by the host
> > > > > (and the guest is either secured or doesn't start), or is it using a
> > > > > model like s390x PV where the guest initiates the transition into
> > > > > secured mode?    
> > > > 
> > > > Like s390x PV it's initiated by the guest.
> > > >   
> > > > > Asking because s390x adds the migration blocker only when the
> > > > > transition is actually happening (i.e. guests that do not transition
> > > > > into secure mode remain migratable.) This has the side effect that you
> > > > > might be able to start a machine with --only-migratable that
> > > > > transitions into a non-migratable machine via a guest action, if I'm
> > > > > not mistaken. Without the new object, I don't see a way to block with
> > > > > --only-migratable; with it, we should be able to do that. Not sure what
> > > > > the desirable behaviour is here.    
> > > >   
> > 
> > The purpose of --only-migratable is specifically to prevent the machine
> > to transition to a non-migrate state IIUC. The guest transition to
> > secure mode should be nacked in this case.
> 
> Yes, that's what happens for s390x: The guest tries to transition, QEMU
> can't add a migration blocker and fails the instruction used for
> transitioning, the guest sees the error.
> 
> The drawback is that we see the failure only when we already launched
> the machine and the guest tries to transition. If I start QEMU with
> --only-migratable, it will refuse to start when non-migratable devices
> are configured in the command line, so I see the issue right from the
> start. (For s390x, that would possibly mean that we should not even
> present the cpu feature bit when only_migratable is set?)

What happens in s390x,  if the guest tries to transition to secure, when
the secure object is NOT configured on the machine?

On PEF systems, the transition fails and the guest is terminated.

My point is -- QEMU will not be able to predict in advance, what the
guest might or might not do, regardless of what devices and objects are
configured in the machine.   If the guest does something unexpected, it
has to be terminated. 

So one possible design choice is to let the guest know that migration
must be facilitated. It can then decide if it wants to continue as a
normal VM or terminate itself, or take the plunge and switch to secure.
A well behaving guest will not switch to secure.

RP
