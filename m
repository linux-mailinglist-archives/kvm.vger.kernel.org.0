Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD63C4ACE16
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 02:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbiBHBr4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 20:47:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344425AbiBHBjR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 20:39:17 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F890C061A73;
        Mon,  7 Feb 2022 17:39:16 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21816aGl005365;
        Tue, 8 Feb 2022 01:39:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=sVx6COLO4Sd9YlLY2EIXXK8MIIh+dQJ2YyW4Db5R0oo=;
 b=Lh/2WaDCeAnPBKpX0CWOjiYFqgsPuu7Mvci25KUObIjkXoEObWs30yepo8vy7NHDZygs
 Ciabd7lPC6rusSJ87kLB9/LRA3It2FNWdIhZx1OeVcc+Mrq++4w1KLQ3oGN+6p2G8vYW
 XEocB+k/NmlDEgIFH/+JLYkI2vKXy7RrEh01Jqu8HuBdsjwGA5a+2MQIdX16yMUNwr7o
 gPo0lOeQ7KvMbXeUTfGB+p8bJIFI563I0IYQLs6cD7DV7+18m8dJAmYQnjrG96Ew+Gja
 iyt7MZ4CdDcu4WHFc9GNN0nLZTdqGH9UX5FQAdQnamEktl3nRYQ1tecMx3VjH1Z7nY11 CQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e355ap16v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 01:39:14 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2181dDtS020804;
        Tue, 8 Feb 2022 01:39:13 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e355ap169-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 01:39:13 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2181WWM7028456;
        Tue, 8 Feb 2022 01:39:11 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3e1gv99jd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 01:39:10 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2181T1ks43057468
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 01:29:01 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B85E711C04A;
        Tue,  8 Feb 2022 01:39:04 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2380211C04C;
        Tue,  8 Feb 2022 01:39:04 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.70.169])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue,  8 Feb 2022 01:39:04 +0000 (GMT)
Date:   Tue, 8 Feb 2022 02:38:35 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v17 14/15] s390/ap: notify drivers on config changed and
 scan complete callbacks
Message-ID: <20220208023835.1fc8c6dd.pasic@linux.ibm.com>
In-Reply-To: <573f8647-7479-3561-cd88-035b4db33e36@linux.ibm.com>
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
        <20211021152332.70455-15-akrowiak@linux.ibm.com>
        <20220204114359.4898b9c5.pasic@linux.ibm.com>
        <573f8647-7479-3561-cd88-035b4db33e36@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Q35ZFvgSB15WKZ95VOoEEYhKvc2u_QRC
X-Proofpoint-ORIG-GUID: i67ciEUarlaYDAk_fJb5-51AaOinIXHV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_07,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202080006
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 7 Feb 2022 14:39:31 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> > Back to the topic of locking: it looks to me that on this path you
> > do the filtering and thus the accesses to matrix_mdev->shadow_apcb,
> > matrix_mdev->matrix and matrix_dev->config_info some of which are
> > of type write whithout the matrix_dev->lock held. More precisely
> > only with the matrix_dev->guests_lock held in "read" mode.
> >
> > Did I misread the code? If not, how is that OK?  
> 
> You make a valid point, a struct rw_semaphore is not adequate for the 
> purposes
> it is used in this patch series. It needs to be a mutex.
> 

Good we agree that v17 is racy.

> 
> For v18 which is forthcoming probably this week, I've been reworking the 
> locking
> based on your observation that the struct ap_guest is not necessary given we
> already have a list of the mediated devices which contain the KVM 
> pointer. On the other

[..]
> 
> >
> > BTW I got delayed on my "locking rules" writeup. Sorry for that!  
> 
> No worries, I've been writing up a vfio-ap-locking.rst document to 
> include with the next
> version of the patch series.

I'm looking forward to v18 including that document. I prefer not to
discuss what you wrote about the approach taken in v18 now. It is easier
to me when I have both the text stating the intended design, and the
code that is supposed to adhere to this design.

Regards,
Halil

