Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C50F2B223C
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 18:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgKMR1o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 12:27:44 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9616 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726625AbgKMR1m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Nov 2020 12:27:42 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ADH2FEU093826;
        Fri, 13 Nov 2020 12:27:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=nu4DkgSkeq+ahYOtndzTNtYDygnitE76dMjzoHOM+pc=;
 b=jA5olLTgkXr33NBQQYhInnh49lbCxOep8sxYA4RWk4rbH9MaYqeNb2hpGPYfv2Xl/ai7
 y4NGM1Dowxk4EMWG0X5xNYfxYdv/ntoXW4Xxo5e52veNdH0vf+1QuV1nzmcN+Q2aPH7N
 IPULA/qC0XGTUawGXkBdJPpmV3oc9SK1qYtDL4vPer5SyvtLgBKtN5CoXCgIac6bfZK1
 UlD4hg7FQDNcP5FtPbRvts5tmX07bRR+Q2N3ft/MpxLtQb4AS0lfTrL4LJ5AN/Arqgj7
 vMXERPWjnJtAOkwYNCZuqN2falwdk5AuUAWfz96mbhnKcEEtbe6RlhIM/P0D5jMh8kQp IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34sw97tkat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 12:27:39 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0ADHRc8e009112;
        Fri, 13 Nov 2020 12:27:38 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34sw97tkag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 12:27:38 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ADHLiss009396;
        Fri, 13 Nov 2020 17:27:37 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03wdc.us.ibm.com with ESMTP id 34nk7ac9ej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 17:27:37 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ADHRYib4063954
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Nov 2020 17:27:34 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B11B6A047;
        Fri, 13 Nov 2020 17:27:34 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 123246A04F;
        Fri, 13 Nov 2020 17:27:32 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.152.80])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 13 Nov 2020 17:27:32 +0000 (GMT)
Subject: Re: [PATCH v11 07/14] s390/vfio-ap: sysfs attribute to display the
 guest's matrix
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
 <20201022171209.19494-8-akrowiak@linux.ibm.com>
 <20201028091758.73aa77a3.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <b96fe876-c67a-fe6c-0e3a-7b4948edeef4@linux.ibm.com>
Date:   Fri, 13 Nov 2020 12:27:32 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201028091758.73aa77a3.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-13_10:2020-11-13,2020-11-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 clxscore=1015 adultscore=0 impostorscore=0 suspectscore=3 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011130107
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/28/20 4:17 AM, Halil Pasic wrote:
> On Thu, 22 Oct 2020 13:12:02 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> +static ssize_t guest_matrix_show(struct device *dev,
>> +				 struct device_attribute *attr, char *buf)
>> +{
>> +	ssize_t nchars;
>> +	struct mdev_device *mdev = mdev_from_dev(dev);
>> +	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>> +
>> +	if (!vfio_ap_mdev_has_crycb(matrix_mdev))
>> +		return -ENODEV;
> I'm wondering, would it make sense to have guest_matrix display the would
> be guest matrix when we don't have a KVM? With the filtering in
> place, the question in what guest_matrix would my (assign) matrix result
> right now if I were to hook up my vfio_ap_mdev to a guest seems a
> legitimate one.

A couple of thoughts here:
* The ENODEV informs the user that there is no guest running
    which makes sense to me given this interface displays the
    guest matrix. The alternative, which I considered, was to
    display an empty matrix (i.e., nothing).
* This would be a pretty drastic change to the design because
    the shadow_apcb - which is what is displayed via this interface - is
    only updated when the guest is started and while it is running (i.e.,
    hot plug of new adapters/domains). Making this change would
    require changing that entire design concept which I am reluctant
    to do at this point in the game.


>
>
>> +
>> +	mutex_lock(&matrix_dev->lock);
>> +	nchars = vfio_ap_mdev_matrix_show(&matrix_mdev->shadow_apcb, buf);
>> +	mutex_unlock(&matrix_dev->lock);
>> +
>> +	return nchars;
>> +}
>> +static DEVICE_ATTR_RO(guest_matrix);

