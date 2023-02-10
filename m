Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD8C691FB3
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 14:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbjBJNYE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 08:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbjBJNYD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 08:24:03 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A0186634
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 05:23:56 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31ADDVjD013157;
        Fri, 10 Feb 2023 13:23:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rVSF2IQryK//tOkrM85NEUI0d6F1GBt0GrNsD7+cSgk=;
 b=EuQj+yrnwf5Mw5ajcWQD7tLEcqBpgswBI3HTKfuinx6Z1CUGzcnxmtzQzWItTytBGHtI
 bvfE+UlUhSy/P53AyY8o1pSbQrZjFGbRO9b82Ub2PGlSOXNxRBaeCm2Hk2lQGJ/JKA2B
 4K0Qmi5N9C1xe7AXzI2HMhLf2NovOcjj3aG2a5cILOX/gDirHfrfLUg5wHJcG/q4jUpK
 GINLFNWaPBbeETGn3KfAh/yUZcXzaj3x5Q9hS+BlpllSuErNbO/4PhK6csZogiDLCQcJ
 ppceHJLxvV9j3GfoUPKdFPWVVZO1JgALQ9gaYCxo3GNhPAkuI/e7ZVJWG3NLyM/IfigQ sA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nnpm9r87k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 13:23:42 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31ADDXgT013201;
        Fri, 10 Feb 2023 13:23:42 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nnpm9r86m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 13:23:41 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31A6Fcu6020984;
        Fri, 10 Feb 2023 13:23:39 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3nhemfqk3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 13:23:39 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31ADNZMs34275802
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 13:23:35 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6FC420049;
        Fri, 10 Feb 2023 13:23:35 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D93720040;
        Fri, 10 Feb 2023 13:23:34 +0000 (GMT)
Received: from [9.171.75.239] (unknown [9.171.75.239])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 10 Feb 2023 13:23:34 +0000 (GMT)
Message-ID: <eac977cd-b325-418d-8ac7-cf26077bd243@linux.ibm.com>
Date:   Fri, 10 Feb 2023 14:23:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v15 00/11] s390x: CPU Topology
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
 <74229e1f3cbb45a92e8b1f26cc8ad744453985a7.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <74229e1f3cbb45a92e8b1f26cc8ad744453985a7.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: i3Y2-LLQekPHBaaif49FT9PFsqsX9Gwv
X-Proofpoint-GUID: HBydW-djqsN5eTnQmyt0TVy5dpb_6LRN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_07,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 malwarescore=0 spamscore=0 adultscore=0 phishscore=0 clxscore=1015
 mlxscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100108
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/9/23 18:14, Nina Schoetterl-Glausch wrote:
> IMO this series looks good overall and like it's nearing the final stages.

Thank you for your helping this.

> 
> You use "polarity" instead of "polarization" a lot.
> Since the PoP uses polarization I think that term would be preferred.

OK

> 
> With the series as it is, one cannot set the polarization via qmp,
> only the entitlement of individual cpus. So only the VM can change
> the polarization.
> Would it be desirable to also be able to set the polarization from the outside?

I do not think so, AFAIK this is not foreseen by the architecture.
My point of view on this is that the application running on the guest is 
the one knowing if it can get use of the heterogeneous CPU provisioning 
provided by the vertical polarization or not.
Horizontal polarization being the default with an homogeneous, or 
considered as default, provisioning.


> 
> Like I said in one response, it would be good to consider if we need an
> polarization_change_in_progress state that refuses requests.
> I'm guessing not, if a request is always completed before the next is handled
> and there is no way to lose requests.
> I don't know how long it would take to change the CPU assignment and if there
> is a chance that could be overwhelmed by too many requests.
> Probably not but something worth thinking about.

Currently, guest request for a topology change is done via the sysfs 
interface by a userland process.
The value returned by the kernel to userland is -BUSY, for both DONE and 
IN_PROGRESS.
So at first sight I do not see a overwhelming problem but having a 
completion indication looks like a good thing to have in a future 
extension in both QEMU and Kernel

> 
> Might be a good idea to add a test case that performs test via qmp.
> So starts an instance with some cpu topology assignments, checks that
> qmp returns the correct topology, hot plugs a cpu and does another check,
> Changes topology attributes, etc.
> I guess this would be an avocado test.

Yes you are right there is a lot to test.
There is already a test for kvm_unit_tests in review to test PTF and 
STSI instruction's interception.
We do not use avocado as far as I know but our hades tests framework for 
the kind of tests you propose.
I never used avocado for now but at first sight, avocado and hades look 
similar.

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
