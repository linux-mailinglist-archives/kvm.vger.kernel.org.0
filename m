Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCDB466315
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 13:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357608AbhLBMLB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 07:11:01 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56144 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241798AbhLBMLA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Dec 2021 07:11:00 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2ArbNi012880;
        Thu, 2 Dec 2021 12:07:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=0AaU34heOxJm/pHeNd4HeOAoDwHSSO/ssc2TPNFIX0A=;
 b=CaNTLmt3PQQae3PnoA34zjXGNYbpEZrQZWBiF97NtA0W+eidmhdwXUq1n9ZZZaCcTTME
 cuhei6RRSym1fEvOPRSYoCKqmIsUHYqGJHmwZ3/udTP81GK0SDWxgGxlISLP3UGKcZu8
 HXihrUIaS79Bo8OqHqVQ2tCAaQsQ3XnIoGcKMSE9R54E2hi4tr2Wrmh4OYCjbwhIHWTf
 LqCrZrGKzbzHAxNdS3H2MJvtviEr+5PZsj7ccahiaqtIJ4wMc6Dsfw2rKkRY3iva9iSy
 NgggRli+rKWAphwUmmJ/3o2Ye1v4gynxam5arKKrIVcTy9fNGb8ykCiftg/vcLdZ9cQ0 tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cpvss9fx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 12:07:37 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B2Bpw2Q007749;
        Thu, 2 Dec 2021 12:07:37 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cpvss9fwn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 12:07:37 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B2BwII4012924;
        Thu, 2 Dec 2021 12:07:34 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3ckcaahgtv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 12:07:34 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B2C7VUq24903972
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Dec 2021 12:07:31 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7026EA4066;
        Thu,  2 Dec 2021 12:07:31 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9BCFA405F;
        Thu,  2 Dec 2021 12:07:30 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.140])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  2 Dec 2021 12:07:30 +0000 (GMT)
Date:   Thu, 2 Dec 2021 13:07:28 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sebastian Mitterle <smitterl@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: firq: floating interrupt
 test
Message-ID: <20211202130728.72570680@p-imbrenda>
In-Reply-To: <95160439-2aa9-765f-9f06-16952e42a495@redhat.com>
References: <20211202095843.41162-1-david@redhat.com>
        <20211202095843.41162-3-david@redhat.com>
        <20211202120113.2dd279a8@p-imbrenda>
        <95160439-2aa9-765f-9f06-16952e42a495@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9sx0GqGxhK41HxqU6worPoRoD7zLeS4o
X-Proofpoint-ORIG-GUID: mveeyAfEpBfPnNsk46Z0UBQv-PdfyZAw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-12-02_07,2021-12-02_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 spamscore=0 mlxlogscore=635 mlxscore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112020077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2 Dec 2021 12:13:08 +0100
David Hildenbrand <david@redhat.com> wrote:

> >> +static void wait_for_sclp_int(void)
> >> +{
> >> +	/* Enable SCLP interrupts on this CPU only. */
> >> +	ctl_set_bit(0, CTL0_SERVICE_SIGNAL);
> >> +
> >> +	set_flag(1);  
> > 
> > why not just WRITE_ONCE/READ_ONCE?  
> 
> Because I shamelessly copied that from s390x/smp.c ;)
> 
> >> +	set_flag(0);
> >> +
> >> +	/* Start CPU #1 and let it wait for the interrupt. */
> >> +	psw.mask = extract_psw_mask();
> >> +	psw.addr = (unsigned long)wait_for_sclp_int;
> >> +	ret = smp_cpu_setup(1, psw);
> >> +	if (ret) {
> >> +		report_skip("cpu #1 not found");  
> > 
> > ...which means that this will hang, and so will all the other report*
> > functions. maybe you should manually unset the flag before calling the
> > various report* functions.  
> 
> Good point, thanks!
> 
> >   
> >> +		goto out;
> >> +	}
> >> +
> >> +	/* Wait until the CPU #1 at least enabled SCLP interrupts. */
> >> +	wait_for_flag();
> >> +
> >> +	/*
> >> +	 * We'd have to jump trough some hoops to sense e.g., via SIGP
> >> +	 * CONDITIONAL EMERGENCY SIGNAL if CPU #1 is already in the
> >> +	 * wait state.
> >> +	 *
> >> +	 * Although not completely reliable, use SIGP SENSE RUNNING STATUS
> >> +	 * until not reported as running -- after all, our SCLP processing
> >> +	 * will take some time as well and make races very rare.
> >> +	 */
> >> +	while(smp_sense_running_status(1));

if you wait here for CPU1 to be in wait state, then why did you need to
wait until it has set the flag earlier? can't you just wait here and not
use the whole wait_for_flag logic? smp_cpu_setup only returns after the
new CPU has started running.

I guess this was also inspired by smp.c :)

> >> +
> >> +	h = alloc_page();  
> > 
> > do you really need to dynamically allocate one page?
> > is there a reason for not using a simple static buffer? (which you can
> > have aligned and statically initialized)  
> 
> I don't really have a strong opinion. I do prefer dynamic alloctions,
> though, if there isn't a good reason not to use them. No need to mess
> with page alignments manually.

fair enough, I also do not have a strong opinion

> >   
> >> +	memset(h, 0, sizeof(*h));  
> > 
> > otherwise, if you really want to allocate the memory, get rid of the
> > memset; the allocator always returns zeroed memory (unless you
> > explicitly ask not to by using flags)  
> 
> Right. "special" FLAG_DONTZERO in that semantics in that allocator.
> 
> >   
> >> +	h->length = 4096;
> >> +	ret = servc(SCLP_CMDW_READ_CPU_INFO, __pa(h));
> >> +	if (ret) {
> >> +		report_fail("SCLP_CMDW_READ_CPU_INFO failed");
> >> +		goto out_destroy;
> >> +	}
> >> +
> >> +	/*
> >> +	 * Wait until the interrupt gets delivered on CPU #1, marking the  
> > 
> > why do you expect the interrupt to be delivered on CPU1? could it not
> > be delivered on CPU0?  
> 
> We don't enable SCLP interrupts + external interrupts on CPU #0 because
> we'll only call sclp_setup_int() on CPU #1.

oh right, I had missed that

> 
> >   
> >> +	 * SCLP requests as done.
> >> +	 */
> >> +	sclp_wait_busy();  
> > 
> > this is logically not wrong (and should stay, because it makes clear
> > what you are trying to do), but strictly speaking it's not needed since
> > the report below will hang as long as the SCLP busy flag is set.   
> 
> Right. But it's really clearer to just have this in the code.

yep, which is why I said that this should stay :)

> 
> 

