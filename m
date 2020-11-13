Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADD22B28FF
	for <lists+kvm@lfdr.de>; Sat, 14 Nov 2020 00:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbgKMXNE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 18:13:04 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:65336 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726061AbgKMXNE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Nov 2020 18:13:04 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ADN1RKu002820;
        Fri, 13 Nov 2020 18:12:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=VPXL3sfSTyvYzjoDD7YxBypjIls2SIk04S7hPFAqFus=;
 b=mfXsPJ0tvOaw/MbqjI4Mkm/khVigjwn577vrVzpPHIJEVnXomSF0dzgSecuRNcnh7FKT
 Bc4YVDeTVCxGzZuoTbm8JbazNQUQewuKrHigKeaYvNb7hVFgVsqNA0p2ftpqUTZ0RjWQ
 twr/aZEqJAxNY/a4i/PxSNewmUVDArRArO7pSfhseSdstjlV04x3Jp+xK2HaCJBj0Pp+
 jdsFZz/0SwWFVB1jgOpebzgutAQuQImuAwjl3SyN5Xc0xKCxEt8+RxRFyyRjSsvzWObX
 KledDxDxsPdAwt6RJd9LFsCO6EH6oZwO4eMHXbBsJe0AFZ6ndwvUbYyCHhkCiZ+5voel AQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34sxs2ghay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 18:12:56 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0ADN2IvA008361;
        Fri, 13 Nov 2020 18:12:56 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34sxs2gha9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 18:12:56 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ADN7SI4005941;
        Fri, 13 Nov 2020 23:12:54 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 34nk78bp5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 23:12:54 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ADNCpeY3080816
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Nov 2020 23:12:51 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5AAF64C040;
        Fri, 13 Nov 2020 23:12:51 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A20834C044;
        Fri, 13 Nov 2020 23:12:50 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.46.164])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri, 13 Nov 2020 23:12:50 +0000 (GMT)
Date:   Sat, 14 Nov 2020 00:12:48 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v11 07/14] s390/vfio-ap: sysfs attribute to display the
 guest's matrix
Message-ID: <20201114001248.3b397c8c.pasic@linux.ibm.com>
In-Reply-To: <b96fe876-c67a-fe6c-0e3a-7b4948edeef4@linux.ibm.com>
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
        <20201022171209.19494-8-akrowiak@linux.ibm.com>
        <20201028091758.73aa77a3.pasic@linux.ibm.com>
        <b96fe876-c67a-fe6c-0e3a-7b4948edeef4@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-13_21:2020-11-13,2020-11-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 spamscore=0 impostorscore=0 clxscore=1015 suspectscore=0 mlxlogscore=999
 adultscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011130145
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 Nov 2020 12:27:32 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> 
> 
> On 10/28/20 4:17 AM, Halil Pasic wrote:
> > On Thu, 22 Oct 2020 13:12:02 -0400
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >
> >> +static ssize_t guest_matrix_show(struct device *dev,
> >> +				 struct device_attribute *attr, char *buf)
> >> +{
> >> +	ssize_t nchars;
> >> +	struct mdev_device *mdev = mdev_from_dev(dev);
> >> +	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
> >> +
> >> +	if (!vfio_ap_mdev_has_crycb(matrix_mdev))
> >> +		return -ENODEV;
> > I'm wondering, would it make sense to have guest_matrix display the would
> > be guest matrix when we don't have a KVM? With the filtering in
> > place, the question in what guest_matrix would my (assign) matrix result
> > right now if I were to hook up my vfio_ap_mdev to a guest seems a
> > legitimate one.
> 
> A couple of thoughts here:
> * The ENODEV informs the user that there is no guest running
>     which makes sense to me given this interface displays the
>     guest matrix. The alternative, which I considered, was to
>     display an empty matrix (i.e., nothing).
> * This would be a pretty drastic change to the design because
>     the shadow_apcb - which is what is displayed via this interface - is
>     only updated when the guest is started and while it is running (i.e.,
>     hot plug of new adapters/domains). Making this change would
>     require changing that entire design concept which I am reluctant
>     to do at this point in the game.
> 
> 

No problem. My thinking was, that, because we can do the
assign/unassing ops also for the running guest, that we also have
the code to do the maintenance on the shadow_apcb. In this
series this code is conditional with respect to vfio_ap_mdev_has_crycb().
E.g. 

static ssize_t assign_adapter_store(struct device *dev,                         
                                    struct device_attribute *attr,              
                                    const char *buf, size_t count)              
{                                                                               
[..]                                                                                
        if (vfio_ap_mdev_has_crycb(matrix_mdev))                                
                if (vfio_ap_mdev_filter_guest_matrix(matrix_mdev, true))        
                        vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);

If one were to move the 
vfio_ap_mdev_has_crycb() check into vfio_ap_mdev_commit_shadow_apcb()
then we would have an always up to date shatdow_apcb, we could display.

I don't feel strongly about this. Was just an idea, because if the result
of the filtering is surprising, currently the only to see, without
knowing the algorithm, and possibly the state, and the history of the
system, is to actually start a guest.

Regards,
Halil

