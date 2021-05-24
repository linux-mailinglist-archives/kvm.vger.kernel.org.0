Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7FD38F152
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 18:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbhEXQRa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 12:17:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12078 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232918AbhEXQR2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 12:17:28 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14OG4dm0020170;
        Mon, 24 May 2021 12:15:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=DrvjMI3EBxdgZsRm5hUVcKMed5KOSzIm0p0poRBgU7I=;
 b=awlCksOA8wO/oE75Y4b+FA/58Eo419/0EhuYhrubBrec0sL2kvdy6vp0k9s9GwMBkMa6
 w5brFjErIdu+bzdLGokSpAOZG9So96atuBCaYZR9nH5x9SezjsMNh+Itb3Qh0iiHn/pR
 rzJ7sALtFJGRj2Pt37+kHI2YKlMghnxV7SLGHe2SLDMcTyBbuvnrFVAVq23GfDSWyR9K
 LjELVNO8wxVbFpO0Bkqpm4vSgLXovsIlyRO/Vrm4C3ucHDaVDciwk2vMeS1BDQbxzKe8
 M8BJjlArwCUD8CU/F5z56lE733e/SrDomc4eeoEkiigeu5sKpvwLCDyVndwwHNyfNfDv pA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38repqhkte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 May 2021 12:15:58 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14OG7plf038733;
        Mon, 24 May 2021 12:15:58 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38repqhks5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 May 2021 12:15:57 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14OGBKip016476;
        Mon, 24 May 2021 16:15:54 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 38ps7h8fyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 May 2021 16:15:53 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14OGFoiV20316452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 May 2021 16:15:50 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75CB14203F;
        Mon, 24 May 2021 16:15:50 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A722A42042;
        Mon, 24 May 2021 16:15:49 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.37.230])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Mon, 24 May 2021 16:15:49 +0000 (GMT)
Date:   Mon, 24 May 2021 18:15:48 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
Subject: Re: [PATCH v16 06/14] s390/vfio-ap: refresh guest's APCB by
 filtering APQNs assigned to mdev
Message-ID: <20210524181548.4dbe52bc.pasic@linux.ibm.com>
In-Reply-To: <20210510164423.346858-7-akrowiak@linux.ibm.com>
References: <20210510164423.346858-1-akrowiak@linux.ibm.com>
        <20210510164423.346858-7-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RIR_5a4GtCOQa80qHPekiPEvbcLNYu2E
X-Proofpoint-GUID: 7VqVILMie_E9GoIdmJ3Ae-jvQlXJalKg
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-24_08:2021-05-24,2021-05-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 bulkscore=0 priorityscore=1501
 impostorscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105240096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 May 2021 12:44:15 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> @@ -1601,8 +1676,10 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
>  	mutex_lock(&matrix_dev->lock);
>  	q = dev_get_drvdata(&apdev->device);
>  
> -	if (q->matrix_mdev)
> +	if (q->matrix_mdev) {
>  		vfio_ap_mdev_unlink_queue_fr_mdev(q);
> +		vfio_ap_mdev_refresh_apcb(q->matrix_mdev);
> +	}
>  
>  	vfio_ap_mdev_reset_queue(q, 1);
>  	dev_set_drvdata(&apdev->device, NULL);

At this point we don't know if !!kvm_busy or kvm_busy AFAICT. If
!!kvm_busy, then we may end up changing a shadow_apcb while an other
thread is in the middle of committing it to the SD satellite. That
would be no good.

Regards,
Halil
