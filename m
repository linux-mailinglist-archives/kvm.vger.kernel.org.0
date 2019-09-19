Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8E45B7785
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 12:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732071AbfISKep (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 06:34:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60190 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730959AbfISKeo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Sep 2019 06:34:44 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8JATNTf033543
        for <kvm@vger.kernel.org>; Thu, 19 Sep 2019 06:34:43 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v46914jfa-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 19 Sep 2019 06:34:43 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Thu, 19 Sep 2019 11:34:41 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 19 Sep 2019 11:34:39 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8JAYaka51773498
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Sep 2019 10:34:36 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 870784C04E;
        Thu, 19 Sep 2019 10:34:36 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1AB414C04A;
        Thu, 19 Sep 2019 10:34:36 +0000 (GMT)
Received: from oc2783563651 (unknown [9.152.224.63])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 19 Sep 2019 10:34:36 +0000 (GMT)
Date:   Thu, 19 Sep 2019 12:34:34 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com, pmorel@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com
Subject: Re: [PATCH v6 04/10] s390: vfio-ap: filter CRYCB bits for
 unavailable queue devices
In-Reply-To: <1568410018-10833-5-git-send-email-akrowiak@linux.ibm.com>
References: <1568410018-10833-1-git-send-email-akrowiak@linux.ibm.com>
        <1568410018-10833-5-git-send-email-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19091910-0008-0000-0000-000003186382
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19091910-0009-0000-0000-00004A36E85C
Message-Id: <20190919123434.28a29c00.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-19_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=943 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909190099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 Sep 2019 17:26:52 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> +static void vfio_ap_mdev_get_crycb_matrix(struct ap_matrix_mdev *matrix_mdev)
> +{
> +	unsigned long apid, apqi;
> +	unsigned long masksz = BITS_TO_LONGS(AP_DEVICES) *
> +			       sizeof(unsigned long);
> +
> +	memset(matrix_mdev->crycb.apm, 0, masksz);
> +	memset(matrix_mdev->crycb.apm, 0, masksz);
> +	memcpy(matrix_mdev->crycb.adm, matrix_mdev->matrix.adm, masksz);
> +
> +	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm,
> +			     matrix_mdev->matrix.apm_max + 1) {
> +		for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
> +				     matrix_mdev->matrix.aqm_max + 1) {
> +			if (vfio_ap_find_queue(AP_MKQID(apid, apqi))) {
> +				if (!test_bit_inv(apid, matrix_mdev->crycb.apm))
> +					set_bit_inv(apid,
> +						    matrix_mdev->crycb.apm);
> +				if (!test_bit_inv(apqi, matrix_mdev->crycb.aqm))
> +					set_bit_inv(apqi,
> +						    matrix_mdev->crycb.aqm);
> +			}
> +		}
> +	}
> +}

Even with the discussed typo fixed (zero crycb.aqm) this procedure does
not make sense to me. :(

If in doubt please consider the following example:
matrix_mdev->matrix.apm and matrix_mdev->matrix.aqm have both just bits
0 and 1 set (i.e. first byte 0xC0 the rest of the bytes 0x0). Queues
bound to the vfio_ap driver (0,0), (0,1), (1,0); not bound to vfio_ap is
however (1,1). If I read this correctly this filtering logic would grant
access to (1,1) which seems to contradict with the stated intention.

Regards,
Halil



