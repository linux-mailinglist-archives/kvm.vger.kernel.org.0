Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26242F37C0
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 18:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389393AbhALR4p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 12:56:45 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62268 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731029AbhALR4o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 12:56:44 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CHYrMh038909;
        Tue, 12 Jan 2021 12:55:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=MHWdrGw14uYtb4TGJ5A7+n2JEJmQ4jGo6SgmNA4cpFk=;
 b=SfzK4ajuPVM373mTedmtjd5b0ooqMqreOnkpGPfihUZie7VQh9tn57digjIYRr/oiu7S
 fn4KSzU+VMn3lCfDDXk6W+MglybbwafN5hAA83g9MOJp14zU2vdLGc4k/f/jTYy+UVJ8
 bTMztPnwCH35PZqf9mRaLwxmXLh56X9ol23VIH26zb4fgUykihcQROFw9Z7dY86Q7wB1
 Z7SIN+WOFp27caRBgxbuEDThhbC74+fxvos0mq6gQYtR5NRjdqJy337kaD7KBJkUx2Pf
 PYFtnDpzbgAFNe/2pXBlzfGKIaWejBcrxHOjBucfzhGUrGTtVfFQz6TV15F+GmJnOo+K dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361g9y0dte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 12:55:59 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10CHYw5M038995;
        Tue, 12 Jan 2021 12:55:58 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361g9y0dsu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 12:55:58 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CHq942021951;
        Tue, 12 Jan 2021 17:55:56 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 35ydrdbjrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 17:55:56 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CHtr4K42992000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 17:55:53 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BC334C040;
        Tue, 12 Jan 2021 17:55:53 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADBA44C04E;
        Tue, 12 Jan 2021 17:55:52 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.60.135])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue, 12 Jan 2021 17:55:52 +0000 (GMT)
Date:   Tue, 12 Jan 2021 18:55:50 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v13 09/15] s390/vfio-ap: allow hot plug/unplug of AP
 resources using mdev device
Message-ID: <20210112185550.1ac49768.pasic@linux.ibm.com>
In-Reply-To: <20210112021251.0d989225.pasic@linux.ibm.com>
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
        <20201223011606.5265-10-akrowiak@linux.ibm.com>
        <20210112021251.0d989225.pasic@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_12:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 impostorscore=0 clxscore=1015 lowpriorityscore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101120099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 12 Jan 2021 02:12:51 +0100
Halil Pasic <pasic@linux.ibm.com> wrote:

> > @@ -1347,8 +1437,11 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
> >  	apqi = AP_QID_QUEUE(q->apqn);
> >  	vfio_ap_mdev_reset_queue(apid, apqi, 1);
> >  
> > -	if (q->matrix_mdev)
> > +	if (q->matrix_mdev) {
> > +		matrix_mdev = q->matrix_mdev;
> >  		vfio_ap_mdev_unlink_queue(q);
> > +		vfio_ap_mdev_refresh_apcb(matrix_mdev);
> > +	}
> >  
> >  	kfree(q);
> >  	mutex_unlock(&matrix_dev->lock);  

Shouldn't we first remove the queue from the APCB and then
reset? Sorry, I missed this one yesterday.

Regards,
Halil
