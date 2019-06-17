Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64313486DC
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 17:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728315AbfFQPVs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 11:21:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64756 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728203AbfFQPVs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jun 2019 11:21:48 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5HF8g5G108904
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2019 11:21:45 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t6bmh5dv3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2019 11:21:45 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <akrowiak@linux.ibm.com>;
        Mon, 17 Jun 2019 16:21:44 +0100
Received: from b03cxnp07029.gho.boulder.ibm.com (9.17.130.16)
        by e35.co.us.ibm.com (192.168.1.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 17 Jun 2019 16:21:40 +0100
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5HFLa9332178652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 15:21:36 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 406EE6E04C;
        Mon, 17 Jun 2019 15:21:36 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E2996E059;
        Mon, 17 Jun 2019 15:21:35 +0000 (GMT)
Received: from [9.60.84.60] (unknown [9.60.84.60])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 17 Jun 2019 15:21:35 +0000 (GMT)
Subject: Re: [PATCH v4 7/7] s390: vfio-ap: update documentation
To:     Harald Freudenberger <freude@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, cohuck@redhat.com, frankja@linux.ibm.com,
        david@redhat.com, mjrosato@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, pmorel@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com
References: <1560454780-20359-1-git-send-email-akrowiak@linux.ibm.com>
 <1560454780-20359-8-git-send-email-akrowiak@linux.ibm.com>
 <e9294d44-084b-5fc2-a3c8-77b279b5fff4@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Date:   Mon, 17 Jun 2019 11:21:34 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <e9294d44-084b-5fc2-a3c8-77b279b5fff4@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19061715-0012-0000-0000-00001744E946
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011279; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01219310; UDB=6.00641340; IPR=6.01000452;
 MB=3.00027346; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-17 15:21:42
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061715-0013-0000-0000-000057B9709C
Message-Id: <8171bedd-1895-06fd-302c-3806aef23129@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906170136
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/17/19 7:42 AM, Harald Freudenberger wrote:
> On 13.06.19 21:39, Tony Krowiak wrote:
>> This patch updates the vfio-ap documentation to include the information
>> below.
>>
>> Changes made to the mdev matrix assignment interfaces:
>>
>> * Allow assignment of APQNs that are not bound to the vfio-ap device
>>    driver as long as they are not owned by a zcrypt driver as identified
>>    in the AP bus sysfs apmask and aqmask interfaces.
>>
>> * Allow assignment of an AP resource to a mediated device which is in use
>>    by a guest to hot plug an adapter, domain and control domain into a
>>    running guest.
>>
>> * Allow unassignment of an AP resource from a mediated device which is in
>>    use by a guest to hot unplug an adapter, domain and control domain from
>>    a running guest.
>>
>> This patch also:
>>
>> * Clarifies the section on configuring the AP bus's apmask and aqmask.
>>
>> * Adds sections on dynamic configuration using the SE or SCLP command.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   Documentation/s390/vfio-ap.txt | 292 ++++++++++++++++++++++++++++++-----------
>>   1 file changed, 213 insertions(+), 79 deletions(-)
>>
>> diff --git a/Documentation/s390/vfio-ap.txt b/Documentation/s390/vfio-ap.txt
>> index 65167cfe4485..9372a6570ce1 100644
>> --- a/Documentation/s390/vfio-ap.txt
>> +++ b/Documentation/s390/vfio-ap.txt
>> @@ -81,10 +81,19 @@ definitions:
>>     which the AP command is to be sent for processing.
>>   
>>     The AP bus will create a sysfs device for each APQN that can be derived from
>> -  the cross product of the AP adapter and usage domain numbers detected when the
>> -  AP bus module is loaded. For example, if adapters 4 and 10 (0x0a) and usage
>> -  domains 6 and 71 (0x47) are assigned to the LPAR, the AP bus will create the
>> -  following sysfs entries:
>> +  the Cartesian product of the AP adapter and usage domain numbers detected when
>> +  the AP bus module is loaded. For example, if adapters 4 and 10 (0x0a) and
>> +  usage domains 6 and 71 (0x47) are assigned to the LPAR, the Cartesian product
>> +  would be defined by the following table:
>> +
>> +		        06           71
>> +		   +-----------+-----------+
>> +		04 |  (04,06)  |  (04,47)  |
>> +		   +-----------|-----------+
>> +		10 |  (0a,06)  |  (0a,47)  |
>> +		   +-----------|-----------+
>> +
> These ascii pictures are nice and show very lovely how this works ...
> but you use the domain id as column (x) and the adapter id as row (y).
> Then the APQNs are shown in (y,x) writing then following the scheme
> (card,domain).

I'll fix this.

>> +  The AP bus will create the following sysfs entries:
>>   
>>       /sys/devices/ap/card04/04.0006
>>       /sys/devices/ap/card04/04.0047
>> @@ -146,10 +155,20 @@ If you recall from the description of an AP Queue, AP instructions include
>>   an APQN to identify the AP queue to which an AP command-request message is to be
>>   sent (NQAP and PQAP instructions), or from which a command-reply message is to
>>   be received (DQAP instruction). The validity of an APQN is defined by the matrix
>> -calculated from the APM and AQM; it is the cross product of all assigned adapter
>> -numbers (APM) with all assigned queue indexes (AQM). For example, if adapters 1
>> -and 2 and usage domains 5 and 6 are assigned to a guest, the APQNs (1,5), (1,6),
>> -(2,5) and (2,6) will be valid for the guest.
>> +calculated from the APM and AQM; it is the Cartesian product of all assigned
>> +adapter numbers (APM) with all assigned queue indexes (AQM). For example, if
>> +adapters 1 and 2 and usage domains 5 and 6 are assigned to a guest:
>> +
>> +
>> +		        05           06
>> +		   +-----------+-----------+
>> +		01 |  (01,05)  |  (01,06)  |
>> +		   +-----------|-----------+
>> +		02 |  (02,05)  |  (02,06)  |
>> +		   +-----------|-----------+
>> +
>> +
>> +APQNs (01,05), (01,06), (02,05) and (02,06) will be valid for the guest.
>>   
>>   The APQNs can provide secure key functionality - i.e., a private key is stored
>>   on the adapter card for each of its domains - so each APQN must be assigned to
>> @@ -349,8 +368,9 @@ matrix device.
>>         number of the the usage domain is echoed to the respective attribute
>>         file.
>>       * matrix:
>> -      A read-only file for displaying the APQNs derived from the cross product
>> -      of the adapter and domain numbers assigned to the mediated matrix device.
>> +      A read-only file for displaying the APQNs derived from the Caresian
>> +      product of the adapter and domain numbers assigned to the mediated matrix
>> +      device.
>>       * assign_control_domain:
>>       * unassign_control_domain:
>>         Write-only attributes for assigning/unassigning an AP control domain
>> @@ -438,9 +458,10 @@ guest use.
>>   Example:
>>   =======
>>   Let's now provide an example to illustrate how KVM guests may be given
>> -access to AP facilities. For this example, we will show how to configure
>> -three guests such that executing the lszcrypt command on the guests would
>> -look like this:
>> +access to AP facilities. For this example, we will assume that adapters 4, 5
>> +and 6 and domains 4, 71 (0x47), 171 (0xab) and 255 (0xff) are assigned to the
>> +LPAR and are online. We will show how to configure three guests such that
>> +executing the lszcrypt command on the guests would look like this:
>>   
>>   Guest1
>>   ------
>> @@ -466,7 +487,7 @@ Guest2
>>   CARD.DOMAIN TYPE  MODE
>>   ------------------------------
>>   06          CEX5A Accelerator
>> -06.0047     CEX5A Accelerator
>> +06.0047     CEX5A AcceleratorNote that this directory may contain additional bindings depending upon what
> This line looks somehow weird.

Sometimes my editor does weird things like this. I'll fix it.

>>   06.00ff     CEX5A Accelerator
>>   
>>   These are the steps:
>> @@ -513,35 +534,44 @@ These are the steps:
>>      /sys/bus/ap/aqmask
>>   
>>      The 'apmask' is a 256-bit mask that identifies a set of AP adapter IDs
>> -   (APID). Each bit in the mask, from left to right (i.e., from most significant
>> -   to least significant bit in big endian order), corresponds to an APID from
>> -   0-255. If a bit is set, the APID is marked as usable only by the default AP
>> -   queue device drivers; otherwise, the APID is usable by the vfio_ap
>> -   device driver.
>> +   (APID). Each bit in the mask, from left to right, corresponds to an APID from
>> +   0-255.
>>   
>>      The 'aqmask' is a 256-bit mask that identifies a set of AP queue indexes
>> -   (APQI). Each bit in the mask, from left to right (i.e., from most significant
>> -   to least significant bit in big endian order), corresponds to an APQI from
>> -   0-255. If a bit is set, the APQI is marked as usable only by the default AP
>> -   queue device drivers; otherwise, the APQI is usable by the vfio_ap device
>> -   driver.
>> +   (APQI). Each bit in the mask, from left to right, corresponds to an APQI from
>> +   0-255.
>> +
>> +   The Cartesian product of the APIDs set in the apmask and the APQIs set in
>> +   the aqmask identify the APQNs of AP queue devices owned by the zcrypt
>> +   device drivers.
>> +
>> +   Take, for example, the following masks:
>>   
>> -   Take, for example, the following mask:
>> +     apmask: 0x7000000000000000000000000000000000000000000000000000000000000000
>>   
>> -      0x7dffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
>> +     aqmask: 0x0180000000000000000000000000000000000000000000000000000000000000
>>   
>> -    It indicates:
>> +   The bits set in apmask are bits 1, 2 and 3. The bits set in aqmask are bits
>> +   7 and 8. The Cartesian product of the bits set in the two masks is:
>>   
>> -      1, 2, 3, 4, 5, and 7-255 belong to the default drivers' pool, and 0 and 6
>> -      belong to the vfio_ap device driver's pool.
>> +             07           08
>> +        +-----------+-----------+
>> +     01 |  (01,07)  |  (01,08)  |
>> +        +-----------|-----------+
>> +     02 |  (02,07)  |  (02,08)  |
>> +        +-----------|-----------+
>> +     03 |  (03,07)  |  (03,08)  |
>> +        +-----------|-----------+
>>   
>> -   The APQN of each AP queue device assigned to the linux host is checked by the
>> -   AP bus against the set of APQNs derived from the cross product of APIDs
>> -   and APQIs marked as usable only by the default AP queue device drivers. If a
>> -   match is detected,  only the default AP queue device drivers will be probed;
>> -   otherwise, the vfio_ap device driver will be probed.
>> +   The masks indicate that the queues with APQNs (01,07), (01,08), (02,07),
>> +   (02,08), (03,07) and (03,08) are owned by the zcrypt drivers. When the AP bus
>> +   detects an AP queue device, its APQN is checked against the set of APQNs
>> +   derived from the apmask and aqmask. If a match is detected, the zcrypt
>> +   device driver registered for the device type of the queue will be probed. If
>> +   a match is not detected and the device type of the queue is CEX4 or newer,
>> +   the vfio_ap device driver will be probed.
>>   
>> -   By default, the two masks are set to reserve all APQNs for use by the default
>> +   By default, the two masks are set to reserve all APQNs for use by the zcrypt
>>      AP queue device drivers. There are two ways the default masks can be changed:
>>   
>>      1. The sysfs mask files can be edited by echoing a string into the
>> @@ -554,8 +584,7 @@ These are the steps:
>>   
>>              0x4100000000000000000000000000000000000000000000000000000000000000
>>   
>> -        Keep in mind that the mask reads from left to right (i.e., most
>> -        significant to least significant bit in big endian order), so the mask
>> +        Keep in mind that the mask reads from left to right, so the mask
>>           above identifies device numbers 1 and 7 (01000001).
>>   
>>           If the string is longer than the mask, the operation is terminated with
>> @@ -563,7 +592,7 @@ These are the steps:
>>   
>>         * Individual bits in the mask can be switched on and off by specifying
>>           each bit number to be switched in a comma separated list. Each bit
>> -        number string must be prepended with a ('+') or minus ('-') to indicate
>> +        number string must be prefixed with a ('+') or minus ('-') to indicate
>>           the corresponding bit is to be switched on ('+') or off ('-'). Some
>>           valid values are:
>>   
>> @@ -594,19 +623,26 @@ These are the steps:
>>               aqmask:
>>               0x4000000000000000000000000000000000000000000000000000000000000000
>>   
>> -         Resulting in these two pools:
>> -
>> -            default drivers pool:    adapter 0-15, domain 1
>> -            alternate drivers pool:  adapter 16-255, domains 0, 2-255
>> +Recall that the Cartesian product of the APIDs set in the apmask and the APQIs
>> +set in the aqmask identify the APQNs of AP queue devices owned by the zcrypt
>> +device drivers. If an attempt is made to modify the apmask or aqmask such that
>> +one or more APQNs changes ownership from a the vfio_ap device driver to a zcrypt
>> +device driver and the APQN is assigned to a mediated device (see step 3 below),
>> +the operation will fail with an error ('Address already in use').
>>   
>>      Securing the APQNs for our example:
>>      ----------------------------------
>> -   To secure the AP queues 05.0004, 05.0047, 05.00ab, 05.00ff, 06.0004, 06.0047,
>> -   06.00ab, and 06.00ff for use by the vfio_ap device driver, the corresponding
>> -   APQNs can either be removed from the default masks:
>> +   There is no way to secure the specific AP queues 05.0004, 05.0047, 05.00ab,
>> +   05.00ff, 06.0004, 06.0047, 06.00ab, and 06.00ff for use by the vfio_ap device
>> +   driver, so we are left with either securing all queues on adapters 05 and
>> +   06, or queues 0004, 0047, 00ab and 00ff can be secured on all adapters.
>> +
>> +   To secure all queues on adapters 05 and 05:
>>   
>>         echo -5,-6 > /sys/bus/ap/apmask
>>   
>> +   To secure queues 0004, 0047, 00ab, and 00ff on all adapters:
>> +
>>         echo -4,-0x47,-0xab,-0xff > /sys/bus/ap/aqmask
>>   
>>      Or the masks can be set as follows:
>> @@ -617,14 +653,20 @@ These are the steps:
>>         echo 0xf7fffffffffffffffeffffffffffffffffffffffffeffffffffffffffffffffe \
>>         > aqmask
>>   
>> -   This will result in AP queues 05.0004, 05.0047, 05.00ab, 05.00ff, 06.0004,
>> -   06.0047, 06.00ab, and 06.00ff getting bound to the vfio_ap device driver. The
>> -   sysfs directory for the vfio_ap device driver will now contain symbolic links
>> -   to the AP queue devices bound to it:
>> +   For this example, we will choose to secure queues 0004, 0047, 00ab, and 00ff
>> +   on all adapters. This will result in AP queues 04.0004, 04.0047, 04.00ab,
>> +   04.00ff, 05.0004, 05.0047, 05.00ab, 05.00ff, 06.0004, 06.0047, 06.00ab and
>> +   06.00ff getting bound to the vfio_ap device driver. The sysfs directory for
>> +   the vfio_ap device driver will now contain symbolic links to the AP queue
>> +   devices bound to it:
>>   
>>      /sys/bus/ap
>>      ... [drivers]
>>      ...... [vfio_ap]
>> +   ......... [04.0004]
>> +   ......... [04.0047]
>> +   ......... [04.00ab]
>> +   ......... [04.00ff]
>>      ......... [05.0004]
>>      ......... [05.0047]
>>      ......... [05.00ab]
>> @@ -641,11 +683,12 @@ These are the steps:
>>      future and for which there are few older systems on which to test.
>>   
>>      The administrator, therefore, must take care to secure only AP queues that
>> -   can be bound to the vfio_ap device driver. The device type for a given AP
>> -   queue device can be read from the parent card's sysfs directory. For example,
>> -   to see the hardware type of the queue 05.0004:
>> +   can be bound to the vfio_ap device driver, or those queues will not get bound
>> +   to any driver. The device type for a given AP queue device can be read from
>> +   the parent card's sysfs directory. For example, to see the hardware type of
>> +   the queue 05.0004:
>>   
>> -   cat /sys/bus/ap/devices/card05/hwtype
>> +      cat /sys/bus/ap/devices/card05/hwtype
>>   
>>      The hwtype must be 10 or higher (CEX4 or newer) in order to be bound to the
>>      vfio_ap device driver.
>> @@ -747,37 +790,48 @@ These are the steps:
>>        higher than the maximum is specified, the operation will terminate with
>>        an error (ENODEV).
>>   
>> -   * All APQNs that can be derived from the adapter ID and the IDs of
>> -     the previously assigned domains must be bound to the vfio_ap device
>> -     driver. If no domains have yet been assigned, then there must be at least
>> -     one APQN with the specified APID bound to the vfio_ap driver. If no such
>> -     APQNs are bound to the driver, the operation will terminate with an
>> -     error (EADDRNOTAVAIL).
>> +   * Each APQN that can be derived from the adapter ID and the IDs of
>> +     the previously assigned domains must not be reserved for use by the
>> +     zcrypt device drivers as specified by the /sys/bus/ap/apmask and
>> +     /sys/bus/ap/aqmask syfs interfaces. If any APQN is reserved, the operation
>> +     will terminate with an error (EADDRNOTAVAIL).
>>   
>> -     No APQN that can be derived from the adapter ID and the IDs of the
>> +   * No APQN that can be derived from the adapter ID and the IDs of the
>>        previously assigned domains can be assigned to another mediated matrix
>>        device. If an APQN is assigned to another mediated matrix device, the
>>        operation will terminate with an error (EADDRINUSE).
>>   
>> +   Note that adapters that are currently not available to the host may be
>> +   assigned to the mediated device. If the adapter subsequently becomes
>> +   available while a guest is using the mediated device, it will automatically
>> +   become available to the guest.
>> +
>>      In order to successfully assign a domain:
>>   
>>      * The domain number specified must represent a value from 0 up to the
>>        maximum domain number configured for the system. If a domain number
>>        higher than the maximum is specified, the operation will terminate with
>> -     an error (ENODEV).
>> +     an error (ENODEV). The maximum domain number can be determined by
>> +     printing the sysfs /sys/bus/ap/ap_max_domain_id attribute:
>>   
>> -   * All APQNs that can be derived from the domain ID and the IDs of
>> -     the previously assigned adapters must be bound to the vfio_ap device
>> -     driver. If no domains have yet been assigned, then there must be at least
>> -     one APQN with the specified APQI bound to the vfio_ap driver. If no such
>> -     APQNs are bound to the driver, the operation will terminate with an
>> -     error (EADDRNOTAVAIL).
>> +        cat /sys/bus/ap/ap_max_domain_id
>>   
>> -     No APQN that can be derived from the domain ID and the IDs of the
>> +   * Each APQN that can be derived from the domain ID and the IDs of
>> +     the previously assigned adapters must not be reserved for use by the
>> +     zcrypt device drivers as specified by the /sys/bus/ap/apmask and
>> +     /sys/bus/ap/aqmask syfs interfaces. If any APQN is reserved, the operation
>> +     will terminate with an error (EADDRNOTAVAIL).
>> +
>> +   * No APQN that can be derived from the domain ID and the IDs of the
>>        previously assigned adapters can be assigned to another mediated matrix
>>        device. If an APQN is assigned to another mediated matrix device, the
>>        operation will terminate with an error (EADDRINUSE).
>>   
>> +   Note that domains that are currently not available to the host may be
>> +   assigned to the mediated device. If the domain subsequently becomes
>> +   available while a guest is using the mediated device, it will automatically
>> +   become available to the guest.
>> +
>>      In order to successfully assign a control domain, the domain number
>>      specified must represent a value from 0 up to the maximum domain number
>>      configured for the system. If a control domain number higher than the maximum
>> @@ -822,16 +876,96 @@ Using our example again, to remove the mediated matrix device $uuid1:
>>      host. If the mdev matrix device is removed, one may want to also reconfigure
>>      the pool of adapters and queues reserved for use by the default drivers.
>>   
>> -Limitations
>> -===========
>> -* The KVM/kernel interfaces do not provide a way to prevent restoring an APQN
>> -  to the default drivers pool of a queue that is still assigned to a mediated
>> -  device in use by a guest. It is incumbent upon the administrator to
>> -  ensure there is no mediated device in use by a guest to which the APQN is
>> -  assigned lest the host be given access to the private data of the AP queue
>> -  device such as a private key configured specifically for the guest.
>> +Hot plug/unplug via mdev matrix device sysfs interfaces:
>> +=======================================================
>> +If an mdev matrix device is in use by a running guest, AP resources can be
>> +plugged into or unplugged from the guest via the mdev device's sysfs
>> +assignment interfaces. Below are some examples.
>> +
>> +   To plug adapter 10 into a running guest:
>> +
>> +      echo 0xa > assign_adapter
>> +
>> +   To unplug domain 5 from a running guest:
>> +
>> +      echo 5 > unassign_domain
>> +
>> +To display the matrix of a guest using the mdev matrix device:
>> +
>> +   cat guest_matrix
>> +
>> +If you attempt to display the guest matrix when a guest is not using the
>> +mdev matrix device, an error will be displayed (ENODEV). Note that adapters and
>> +domains that are not yet available or not yet assigned to the LPAR can be
>> +assigned and will become available to the guest as soon as they become available
>> +to the host.
>> +
>> +Dynamic Changes to AP Configuration using the Support Element (SE):
>> +==================================================================
>> +The SE can be used to dynamically make the following changes to the AP
>> +configuration for an LPAR in which a linux host is running:
>> +
>> +   * Configure one or more adapters on
>> +
>> +     Configuring an adapter on sets its state to online, thus making it
>> +     available to the LPAR to which it is assigned. When an adapter is
>> +     configured on, it immediately becomes available to the LPAR as well as to
>> +     any guests using a mediated device to which the adapter is assigned.
>> +
>> +   * Configure one or more adapters off
>> +
>> +     Configuring an adapter off sets its state to standby, thus making it
>> +     unavailable to the LPAR to which it is assigned. When an adapter is
>> +     configured off, it immediately becomes unavailable to the LPAR as well as
>> +     to any guests using a mediated device to which the adapter is assigned.
>> +
>> +   * Add adapters or domains to the LPAR configuration
>> +
>> +     Adapters and/or domains can be assigned to an LPAR using the Change LPAR
>> +     Cryptographic Controls task. To make dynamic changes to the AP
>> +     configuration for an LPAR Running a linux guest, the online adapters
>> +     assigned to the LPAR must first be configured off. After performing the
>> +     adapter and/or domain assignments, the AP resources will automatically
>> +     become available to the linux host running in the LPAR as well as any
>> +     guests using a mediated device to which the adpaters and/or domains are
>> +     assigned.
>> +
>> +   * Remove adapters or domains from the LPAR configuration
>> +
>> +     Adapters and/or domains can be unassigned from an LPAR using the Change
>> +     LPAR Cryptographic Controls task. To make dynamic changes to the AP
>> +     configuration for an LPAR Running a linux guest, the online adapters
>> +     assigned to the LPAR must first be configured off. After performing the
>> +     adapter and/or domain unassignments, the AP resources will automatically
>> +     become unavailable to the linux host running in the LPAR as well as any
>> +     guests using a mediated device to which the adpaters and/or domains are
>> +     assigned.
>> +
>> +Dynamic Changes to the AP Configuration using the SCLP command:
>> +==============================================================
>> +The following SCLP commands may be used to dynamically configure AP adapters on
>> +and off:
>> +
>> +* Configure Adjunct Processor
>> +
>> +  The 'Configure Adjunct Processor' command sets an AP adapter's state to
>> +  online, thus making it available to the LPARs to which it is assigned. It will
>> +  likewise become available to any linux guest using a mediated device to which
>> +  the adapter is assigned.
>> +
>> +* Deconfigure Adjunct Processor
>> +
>> +  The 'Deconfigure Adjunct Processor' command sets an AP adapter's state to
>> +  standby, thus making it unavailable to the LPARs to which it is assigned. It
>> +  will likewise become unavailable to any linux guest using a mediated device to
>> +  which the adapter is assigned.
>>   
>> -* Dynamically modifying the AP matrix for a running guest (which would amount to
>> -  hot(un)plug of AP devices for the guest) is currently not supported
>> +Live migration:
>> +==============
>> +Live guest migration is not supported for guests using AP devices. All AP
>> +devices in use by the guest must be unplugged prior to initiating live
>> +migration (see "Hot plug/unplug via mdev matrix device sysfs interfaces" section
>> +above). If you are using QEMU to run your guest and it supports hot plug/unplug
>> +of the vfio-ap device, this would be another option (consult the QEMU
>> +documentation for details).
>>   
>> -* Live guest migration is not supported for guests using AP devices.
> 

