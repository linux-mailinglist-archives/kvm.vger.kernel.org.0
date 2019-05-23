Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1778D28107
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 17:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731107AbfEWPTU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 11:19:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35974 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730709AbfEWPTT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 May 2019 11:19:19 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4NFJBbD016686
        for <kvm@vger.kernel.org>; Thu, 23 May 2019 11:19:18 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2snwtcgqsn-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 May 2019 11:19:15 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Thu, 23 May 2019 16:18:03 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 23 May 2019 16:18:00 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4NFHwbW38731930
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 May 2019 15:17:58 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FCEC11C052;
        Thu, 23 May 2019 15:17:58 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9159611C04A;
        Thu, 23 May 2019 15:17:57 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.30.80])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 23 May 2019 15:17:57 +0000 (GMT)
Date:   Thu, 23 May 2019 17:17:56 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Sebastian Ott <sebott@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>
Subject: Re: [PATCH 05/10] s390/cio: introduce DMA pools to cio
In-Reply-To: <alpine.LFD.2.21.1905081447280.1773@schleppi>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
        <20190426183245.37939-6-pasic@linux.ibm.com>
        <alpine.LFD.2.21.1905081447280.1773@schleppi>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19052315-0008-0000-0000-000002E9B290
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052315-0009-0000-0000-0000225671DA
Message-Id: <20190523171756.4d30233a.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-23_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=892 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905230104
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 May 2019 15:18:10 +0200 (CEST)
Sebastian Ott <sebott@linux.ibm.com> wrote:

> > @@ -224,6 +228,9 @@ struct subchannel *css_alloc_subchannel(struct subchannel_id schid,
> >  	INIT_WORK(&sch->todo_work, css_sch_todo);
> >  	sch->dev.release = &css_subchannel_release;
> >  	device_initialize(&sch->dev);
> > +	sch->dma_mask = css_dev_dma_mask;
> > +	sch->dev.dma_mask = &sch->dma_mask;
> > +	sch->dev.coherent_dma_mask = sch->dma_mask;  
> 
> Could we do:
> 	sch->dev.dma_mask = &sch->dev.coherent_dma_mask;
> 	sch->dev.coherent_dma_mask = css_dev_dma_mask;
> ?

Looks like a good idea to me. We will do it for all 3 (sch, ccw and
css). Thanks!

Regards,
Halil

