Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBA634A609
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 11:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbhCZK72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 06:59:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47432 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229832AbhCZK7D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 06:59:03 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12QAYkK6062621
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 06:59:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=DrWwM8mXqDYJLxs3aiTgWAFeKE9aih5tv84AbUEw1MI=;
 b=PV/e5eAjfvn01IEWs5i10s9/FxfRvA9AEHbLH9R0OchGOa+JQN2dfWCGMkvge1sQ1JBw
 VUuz5PcORa7ekwY3+om+yu66an2HDPu/GsNkti8EwcFCgwTfD824C8eqvNyOSkTgiyo1
 fEGuTFUo1hlWOczO59G8SAHiLviEgOxzgjAgzcuvSe8afufZqkD3oCPsCR2UvL4iznza
 ClN5NtWGWDH53Gz+5vxRu2AL7PTN84yt4J7hQGGfSbFzGYfj7Rh4CSc/z2KBDuWd+O9+
 NPg99E1EAUMe/OhC9QBtxf5oSgwgsIFoEjvTlyH1M0Dt4xijJB3BBQSCQraaVdmIQwMv Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37hcdub6f5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 06:59:03 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12QAYk9Y062640
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 06:59:02 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37hcdub6e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Mar 2021 06:59:02 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12QAwDt5019192;
        Fri, 26 Mar 2021 10:59:00 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 37h15a8jnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Mar 2021 10:59:00 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12QAwvP819792294
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Mar 2021 10:58:57 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3ADC1A4062;
        Fri, 26 Mar 2021 10:58:57 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5643A4060;
        Fri, 26 Mar 2021 10:58:56 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.2.56])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 26 Mar 2021 10:58:56 +0000 (GMT)
Date:   Fri, 26 Mar 2021 11:58:55 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 6/8] s390x: css: testing ssch error
 response
Message-ID: <20210326115855.21427c7d@ibm-vm>
In-Reply-To: <12260eaf-1fc8-00ce-f500-b56e7ad7ae2a@linux.ibm.com>
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
        <1616665147-32084-7-git-send-email-pmorel@linux.ibm.com>
        <20210325170257.2e753967@ibm-vm>
        <12260eaf-1fc8-00ce-f500-b56e7ad7ae2a@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GyXt2s8BO_auofZZgZ1kgjJAQWsynEpR
X-Proofpoint-ORIG-GUID: xWMoql1bnYmICLC85qR5oHSx4czopv-H
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-26_03:2021-03-26,2021-03-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 phishscore=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2103250000 definitions=main-2103260077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 26 Mar 2021 11:41:34 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 3/25/21 5:02 PM, Claudio Imbrenda wrote:
> > On Thu, 25 Mar 2021 10:39:05 +0100
> > Pierre Morel <pmorel@linux.ibm.com> wrote:
> >   
> 
> ...snip...
> 
> 
> Trying to follow your comment, I have some questions:
> 
> 
> >> +	/* 2- ORB address should be lower than 2G */
> >> +	report_prefix_push("ORB Address above 2G");
> >> +	expect_pgm_int();
> >> +	ssch(test_device_sid, (void *)0x80000000);  
> > 
> > another hardcoded address... you should try allocating memory over
> > 2G, and try to use it. put a check if there is enough memory, and
> > skip if you do not have enough memory, like you did below  
> 
> How can I allocate memory above 2G?

alloc_pages_flags(order, AREA_NORMAL)

btw that allocation will fail if there is no free memory available
above 2G

> >   
> >> +	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
> >> +	report_prefix_pop();
> >> +
> >> +	/* 3- ORB address should be available we check 1G*/
> >> +	top = get_ram_size();
> >> +	report_prefix_push("ORB Address must be available");
> >> +	if (top < 0x40000000) {
> >> +		expect_pgm_int();
> >> +		ssch(test_device_sid, (void *)0x40000000);
> >> +		check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
> >> +	} else {
> >> +		report_skip("guest started with more than 1G
> >> memory");  
> > 
> > this is what I meant above. you will need to run this test both
> > with 1G and with 3G of ram (look at the SCLP test, it has the same
> > issue)  
> 
> I do not understand, if I test with 3G RAM, I suppose that the
> framework works right and I have my 3G RAM available.
> Then I can check with an address under 1G and recheck with an address 
> above 1G.
> 
> What is the purpose to check with only 1G memory?

you need to run this test twice, once with 1G and once with 3G.
it's the same test, so it can't know if it is being run with 1G or
3G, so you have to test for it.

when you need a valid address above 2G, you need to make sure you have
that much memory, and when you want an invalid address between 1G and
2G, you have to make sure you have no more than 1G.

> 
> Regards,
> Pierre
> 

