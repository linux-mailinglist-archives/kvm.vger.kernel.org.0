Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 569643305B
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 14:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfFCM5k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 08:57:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43830 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726336AbfFCM5k (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Jun 2019 08:57:40 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x53Cr96r039520
        for <kvm@vger.kernel.org>; Mon, 3 Jun 2019 08:57:39 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sw3tj8pyy-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2019 08:57:38 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Mon, 3 Jun 2019 13:57:37 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 3 Jun 2019 13:57:33 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x53CvVjS52887556
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jun 2019 12:57:31 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D10452051;
        Mon,  3 Jun 2019 12:57:31 +0000 (GMT)
Received: from oc2783563651 (unknown [9.152.224.145])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2C9DD52057;
        Mon,  3 Jun 2019 12:57:31 +0000 (GMT)
Date:   Mon, 3 Jun 2019 14:57:30 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Michael Mueller <mimu@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        KVM Mailing List <kvm@vger.kernel.org>,
        Linux-S390 Mailing List <linux-s390@vger.kernel.org>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: Re: [PATCH v3 2/8] s390/cio: introduce DMA pools to cio
In-Reply-To: <035b4bd3-5856-e8e5-91bf-ba0b5c7c3736@linux.ibm.com>
References: <20190529122657.166148-1-mimu@linux.ibm.com>
        <20190529122657.166148-3-mimu@linux.ibm.com>
        <20190603133745.240c00a7.cohuck@redhat.com>
        <035b4bd3-5856-e8e5-91bf-ba0b5c7c3736@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19060312-0020-0000-0000-000003442F56
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060312-0021-0000-0000-00002197316D
Message-Id: <20190603145730.3e45b8f5.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-03_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906030093
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 3 Jun 2019 14:09:02 +0200
Michael Mueller <mimu@linux.ibm.com> wrote:

> >> @@ -224,6 +226,8 @@ struct subchannel *css_alloc_subchannel(struct subchannel_id schid,
> >>   	INIT_WORK(&sch->todo_work, css_sch_todo);
> >>   	sch->dev.release = &css_subchannel_release;
> >>   	device_initialize(&sch->dev);  
> > 
> > It might be helpful to add a comment why you use 31 bit here...  
> 
> @Halil, please let me know what comment you prefere here...
> 

How about?

/*
 * The physical addresses of some the dma structures that
 * can belong  to a subchannel need to fit 31 bit width (examples ccw,).
 */


> >   
> >> +	sch->dev.coherent_dma_mask = DMA_BIT_MASK(31);
> >> +	sch->dev.dma_mask = &sch->dev.coherent_dma_mask;
> >>   	return sch;
> >>   
> >>   err:
> >> @@ -899,6 +903,8 @@ static int __init setup_css(int nr)
> >>   	dev_set_name(&css->device, "css%x", nr);
> >>   	css->device.groups = cssdev_attr_groups;
> >>   	css->device.release = channel_subsystem_release;  
> > 
> > ...and 64 bit here.  
> 
> and here.

/*
 * We currently allocate notifier bits with this (using css->device
 * as the device argument with the DMA API), and are fine with 64 bit
 * addresses.
 */

Regards,
Halil

