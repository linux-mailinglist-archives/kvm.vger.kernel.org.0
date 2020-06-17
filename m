Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA951FCC37
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 13:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgFQLZx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 07:25:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45728 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725536AbgFQLZx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Jun 2020 07:25:53 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05HB4T92183210;
        Wed, 17 Jun 2020 07:25:52 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31q6hdjyw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 07:25:51 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05HB4nax184414;
        Wed, 17 Jun 2020 07:25:51 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31q6hdjyvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 07:25:51 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05HBGjxb024991;
        Wed, 17 Jun 2020 11:25:49 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 31q6bs8xgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 11:25:49 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05HBPlhP786780
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jun 2020 11:25:47 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9943911C054;
        Wed, 17 Jun 2020 11:25:47 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42F1C11C04C;
        Wed, 17 Jun 2020 11:25:47 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.186.32])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Jun 2020 11:25:47 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v9 11/12] s390x: css: msch, enable test
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
 <1592213521-19390-12-git-send-email-pmorel@linux.ibm.com>
 <20200617105433.6a79e92c.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <c529e53c-3b4e-8c5f-9dc2-4a7a1507a44e@linux.ibm.com>
Date:   Wed, 17 Jun 2020 13:25:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200617105433.6a79e92c.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-17_03:2020-06-17,2020-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 mlxscore=0 priorityscore=1501 cotscore=-2147483648 malwarescore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=999
 spamscore=0 impostorscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006170083
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-17 10:54, Cornelia Huck wrote:
> On Mon, 15 Jun 2020 11:32:00 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> A second step when testing the channel subsystem is to prepare a channel
>> for use.
...snip...
>> +
>> +	/* Read the SCHIB for this subchannel */
>> +	cc = stsch(schid, &schib);
>> +	if (cc) {
>> +		report_info("stsch failed with cc=%d", cc);
> 
> Mention the schid in the message?

Yes:
report_info("stsch: sch %08x failed with cc=%d", schid, cc);

> 
>> +		return cc;
>> +	}
>> +
>> +	if (pmcw->flags & PMCW_ENABLE) {
>> +		report_info("stsch: sch %08x already enabled", schid);
>> +		return 0;
>> +	}
>> +
>> +retry:
>> +	/* Update the SCHIB to enable the channel */
>> +	pmcw->flags |= PMCW_ENABLE;
>> +
>> +	/* Tell the CSS we want to modify the subchannel */
>> +	cc = msch(schid, &schib);
>> +	if (cc) {
>> +		/*
>> +		 * If the subchannel is status pending or
>> +		 * if a function is in progress,
>> +		 * we consider both cases as errors.
>> +		 */
>> +		report_info("msch failed with cc=%d", cc);

added schid here too

>> +		return cc;
>> +	}
>> +
>> +	/*
>> +	 * Read the SCHIB again to verify the enablement
>> +	 */
>> +	cc = stsch(schid, &schib);
>> +	if (cc) {
>> +		report_info("stsch failed with cc=%d", cc);
> 
> Also add the schid here? Maybe also add a marker to distinguish the two
> cases?

changed to:
report_info("stsch: updating sch %08x failed with cc=%d",schid, cc);
                     ^^^
> 
>> +		return cc;
>> +	}
>> +
>> +	if (pmcw->flags & PMCW_ENABLE) {
>> +		report_info("Subchannel %08x enabled after %d retries",
>> +			    schid, retry_count);
>> +		return 0;
>> +	}
>> +
>> +	if (retry_count++ < MAX_ENABLE_RETRIES) {
>> +		mdelay(10); /* the hardware was not ready, give it some time */
>> +		goto retry;
>> +	}
>> +
>> +	report_info("msch: enabling sch %08x failed after %d retries. pmcw flags: %x",
>> +		    schid, retry_count, pmcw->flags);
>> +	return -1;
>> +}
> 
> With the messages updated,
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
